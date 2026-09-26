/* Version-specific callback ABI experiment. No send or network functions.
 * Load with RTLD_NODELETE so asynchronous tasks never point into an unloaded
 * Frida script. Heap closures use this library's paired malloc/free paths.
 */
#include <stdatomic.h>
#include <stdint.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

typedef struct { void *vptr; const char *name; } LabTypeInfo;
typedef struct { void **vptr; unsigned alive, heap; } LabClosure;
typedef int (*ByteSize)(void *);
typedef unsigned char *(*Serialize)(void *, unsigned char *);
enum { RESPONSE_CAPACITY = 4096 };

typedef struct {
    uint32_t live, invoked, destroyed;
    int32_t error_type, error_code;
    uint32_t task_id, response_size, response_skipped;
    unsigned char response[RESPONSE_CAPACITY];
} LabSnapshot;

static _Atomic unsigned live_count, invoke_count, destroy_count;
static LabSnapshot last;
static pthread_mutex_t result_mutex = PTHREAD_MUTEX_INITIALIZER;
static Serialize encode_response;
static void *expected_response_vptr;
static LabTypeInfo lab_type = { 0, "WeChatLabNativeCompletion" };
static void *vtable[11];

static void destroy_only(LabClosure *self) {
    if (self && self->alive) {
        self->alive = 0;
        atomic_fetch_add_explicit(&destroy_count, 1, memory_order_relaxed);
        atomic_fetch_sub_explicit(&live_count, 1, memory_order_release);
    }
}
static void destroy_free(LabClosure *self) {
    if (!self) return;
    unsigned heap = self->heap;
    destroy_only(self);
    if (heap) free(self);
}
static void clone_into(const LabClosure *source, LabClosure *destination) {
    (void)source;
    destination->vptr = &vtable[2];
    destination->alive = 1;
    destination->heap = 0;
    atomic_fetch_add_explicit(&live_count, 1, memory_order_relaxed);
}
static LabClosure *clone_heap(const LabClosure *source) {
    LabClosure *copy = malloc(sizeof(*copy));
    if (!copy) abort();
    clone_into(source, copy);
    copy->heap = 1;
    return copy;
}
static unsigned invoke(LabClosure *self, void **task_ref, int32_t *type, int32_t *code) {
    (void)self;
    pthread_mutex_lock(&result_mutex);
    last.error_type = *type;
    last.error_code = *code;
    last.response_size = 0;
    last.response_skipped = 1;
    void *task = *task_ref;
    if (task) {
        memcpy(&last.task_id, (unsigned char *)task + 8, 4);
        void *response = (unsigned char *)task + 0xf0;
        void **response_vptr = *(void ***)response;
        if (encode_response && response_vptr == expected_response_vptr) {
            ByteSize size_of = (ByteSize)response_vptr[0x48 / sizeof(void *)];
            int size = size_of(response);
            if (size >= 0 && size <= RESPONSE_CAPACITY) {
                unsigned char *end = encode_response(response, last.response);
                if (end == last.response + size) {
                    last.response_size = (unsigned)size;
                    last.response_skipped = 0;
                }
            }
        }
    }
    atomic_fetch_add_explicit(&invoke_count, 1, memory_order_release);
    pthread_mutex_unlock(&result_mutex);
    return 1; /* The verified task manager owns and deletes the Task. */
}
static void *target(LabClosure *self, const LabTypeInfo *info) {
    return info && info->name == lab_type.name ? &self->alive : NULL;
}
static const LabTypeInfo *target_type(LabClosure *self) { (void)self; return &lab_type; }

int lab_configure(void *type_info_vptr, void *serializer, void *response_vptr) {
    if (atomic_load_explicit(&live_count, memory_order_acquire)) return 0;
    pthread_mutex_lock(&result_mutex);
    lab_type.vptr = type_info_vptr;
    encode_response = (Serialize)serializer;
    expected_response_vptr = response_vptr;
    vtable[0] = NULL; vtable[1] = &lab_type;
    vtable[2] = destroy_only; vtable[3] = destroy_free;
    vtable[4] = clone_heap; vtable[5] = clone_into;
    vtable[6] = destroy_only; vtable[7] = destroy_free;
    vtable[8] = invoke; vtable[9] = target; vtable[10] = target_type;
    memset(&last, 0, sizeof(last));
    atomic_store(&invoke_count, 0); atomic_store(&destroy_count, 0);
    pthread_mutex_unlock(&result_mutex);
    return 1;
}
void *lab_new(void) { return clone_heap(NULL); }
void lab_release_unsubmitted(void *object) { destroy_free(object); }
unsigned lab_snapshot(LabSnapshot *out) {
    pthread_mutex_lock(&result_mutex);
    unsigned invoked = atomic_load_explicit(&invoke_count, memory_order_acquire);
    memcpy(out, &last, sizeof(*out));
    out->live = atomic_load_explicit(&live_count, memory_order_acquire);
    out->invoked = invoked;
    out->destroyed = atomic_load_explicit(&destroy_count, memory_order_relaxed);
    pthread_mutex_unlock(&result_mutex);
    return sizeof(*out);
}

/* Standalone ABI/lifetime checks; never called inside the WeChat process. */
unsigned lab_selftest(void) {
    if (!lab_configure(NULL, NULL, NULL)) return 0;
    unsigned checks = 0;
    LabClosure *original = lab_new();
    LabClosure *copy = ((LabClosure *(*)(const LabClosure *))original->vptr[2])(original);
    LabClosure local;
    ((void (*)(const LabClosure *, LabClosure *))original->vptr[3])(original, &local);
    if (atomic_load(&live_count) == 3 && original != copy) checks |= 1;
    const LabTypeInfo *info = ((const LabTypeInfo *(*)(LabClosure *))copy->vptr[8])(copy);
    if (((void *(*)(LabClosure *, const LabTypeInfo *))copy->vptr[7])(copy, info) == &copy->alive) checks |= 2;
    LabTypeInfo other = {NULL, "OtherType"};
    if (!((void *(*)(LabClosure *, const LabTypeInfo *))copy->vptr[7])(copy, &other)) checks |= 4;
    unsigned char task[0x130] = {0}; uint32_t id = 42;
    memcpy(task + 8, &id, 4); void *task_ptr = task;
    int32_t error_type = 7, error_code = -8;
    unsigned result = ((unsigned (*)(LabClosure *, void **, int32_t *, int32_t *))copy->vptr[6])(copy, &task_ptr, &error_type, &error_code);
    if (result == 1 && last.task_id == 42 && last.error_type == 7 && last.error_code == -8) checks |= 8;
    ((void (*)(LabClosure *))local.vptr[4])(&local);
    ((void (*)(LabClosure *))original->vptr[5])(original);
    ((void (*)(LabClosure *))copy->vptr[1])(copy);
    if (atomic_load(&live_count) == 0 && atomic_load(&destroy_count) == 3 && atomic_load(&invoke_count) == 1) checks |= 16;
    return checks;
}
