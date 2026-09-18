/* Own disposable process: old/new threads and calls after debugger detach. */
#include <windows.h>
#include <stdio.h>

static volatile LONG hits = 0;
static char go_file[MAX_PATH], post_file[MAX_PATH];
static char fire_file[MAX_PATH], after_detach_capture_file[MAX_PATH];
static char registers_before_file[MAX_PATH], registers_after_file[MAX_PATH];
static char registers_before_tmp[MAX_PATH], registers_after_tmp[MAX_PATH];
static DWORD sample_thread_ids[3];
static int capture_registers = 0;
__attribute__((noinline)) void fixture_marker(void) { InterlockedIncrement(&hits); }

static int await_file(const char *path) {
    ULONGLONG deadline = GetTickCount64() + 20000;
    while (GetFileAttributesA(path) == INVALID_FILE_ATTRIBUTES) {
        if (GetTickCount64() > deadline) return 0;
        Sleep(10);
    }
    return 1;
}

static DWORD WINAPI worker(void *unused) {
    (void)unused;
    if (!await_file(go_file)) return 2;
    if (capture_registers && !await_file(fire_file)) return 4;
    fixture_marker();
    if (!await_file(post_file)) return 3;
    fixture_marker();
    return 0;
}

typedef struct {
    int ok;
    ULONGLONG dr[4];
    ULONGLONG dr7;
    int resume_ok;
} RegisterSample;

static int sample_thread(DWORD thread_id, RegisterSample *sample) {
    HANDLE thread;
    DWORD suspend_result, resume_result;
    CONTEXT context;

    ZeroMemory(sample, sizeof(*sample));
    thread = OpenThread(THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT |
                        THREAD_QUERY_LIMITED_INFORMATION, FALSE, thread_id);
    if (!thread) return 0;
    if (GetProcessIdOfThread(thread) != GetCurrentProcessId()) {
        CloseHandle(thread);
        return 0;
    }
    suspend_result = SuspendThread(thread);
    if (suspend_result != (DWORD)-1) {
        ZeroMemory(&context, sizeof(context));
        context.ContextFlags = CONTEXT_DEBUG_REGISTERS;
        if (GetThreadContext(thread, &context)) {
            sample->dr[0] = (ULONGLONG)context.Dr0;
            sample->dr[1] = (ULONGLONG)context.Dr1;
            sample->dr[2] = (ULONGLONG)context.Dr2;
            sample->dr[3] = (ULONGLONG)context.Dr3;
            sample->dr7 = (ULONGLONG)context.Dr7;
            sample->ok = 1;
        }
        resume_result = ResumeThread(thread);
        sample->resume_ok = resume_result != (DWORD)-1;
    }
    CloseHandle(thread);
    return sample->ok && sample->resume_ok;
}

static int write_register_snapshot(const char *final_path, const char *tmp_path) {
    FILE *output;
    int all_ok = 1, write_ok = 1;
    int index;

    output = fopen(tmp_path, "w");
    if (!output) return 0;
    if (fputs("[\n", output) == EOF) write_ok = 0;
    for (index = 0; index < 3; ++index) {
        RegisterSample sample;
        int sampled = sample_thread(sample_thread_ids[index], &sample);
        if (!sampled) all_ok = 0;
        if (fprintf(output,
                    "{\"ok\":%s,\"dr\":[%llu,%llu,%llu,%llu],"
                    "\"dr7\":%llu,\"resume_ok\":%s}%s\n",
                    sample.ok ? "true" : "false",
                    (unsigned long long)sample.dr[0],
                    (unsigned long long)sample.dr[1],
                    (unsigned long long)sample.dr[2],
                    (unsigned long long)sample.dr[3],
                    (unsigned long long)sample.dr7,
                    sample.resume_ok ? "true" : "false",
                    index == 2 ? "" : ",") < 0) {
            write_ok = 0;
        }
    }
    if (fputs("]\n", output) == EOF) write_ok = 0;
    if (fclose(output) != 0) write_ok = 0;
    if (!write_ok || !MoveFileExA(tmp_path, final_path,
                                  MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH)) {
        DeleteFileA(tmp_path);
        return 0;
    }
    return all_ok;
}

static DWORD WINAPI register_worker(void *unused) {
    (void)unused;
    if (!write_register_snapshot(registers_before_file, registers_before_tmp)) return 20;
    if (!await_file(after_detach_capture_file)) return 21;
    if (!write_register_snapshot(registers_after_file, registers_after_tmp)) return 22;
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 2) return 4;
    snprintf(go_file, MAX_PATH, "%s\\go", argv[1]);
    snprintf(post_file, MAX_PATH, "%s\\post", argv[1]);
    snprintf(fire_file, MAX_PATH, "%s\\fire", argv[1]);
    snprintf(after_detach_capture_file, MAX_PATH, "%s\\after-detach-capture", argv[1]);
    snprintf(registers_before_file, MAX_PATH, "%s\\registers-before.json", argv[1]);
    snprintf(registers_after_file, MAX_PATH, "%s\\registers-after.json", argv[1]);
    snprintf(registers_before_tmp, MAX_PATH, "%s\\registers-before.json.tmp", argv[1]);
    snprintf(registers_after_tmp, MAX_PATH, "%s\\registers-after.json.tmp", argv[1]);
    char capture_file[MAX_PATH];
    snprintf(capture_file, MAX_PATH, "%s\\capture-registers", argv[1]);
    capture_registers = GetFileAttributesA(capture_file) != INVALID_FILE_ATTRIBUTES;
    unsigned char original = *(volatile unsigned char *)(void *)&fixture_marker;
    DWORD old_id, new_id, snapshot_exit_code;
    HANDLE snapshot_thread = NULL;
    HANDLE old_thread = CreateThread(NULL, 0, worker, NULL, 0, &old_id);
    if (!old_thread) return 5;
    char ready[MAX_PATH];
    snprintf(ready, MAX_PATH, "%s\\ready", argv[1]);
    FILE *receipt = fopen(ready, "w");
    if (!receipt) return 6;
    fputs("ready", receipt); fclose(receipt);
    if (!await_file(go_file)) return 7;
    HANDLE new_thread = CreateThread(NULL, 0, worker, NULL, 0, &new_id);
    if (!new_thread) return 8;
    char identities[MAX_PATH];
    snprintf(identities, MAX_PATH, "%s\\thread-identities", argv[1]);
    FILE *identity_receipt = fopen(identities, "w");
    if (!identity_receipt) return 12;
    sample_thread_ids[0] = GetCurrentThreadId();
    sample_thread_ids[1] = old_id;
    sample_thread_ids[2] = new_id;
    fprintf(identity_receipt, "%lu %lu %lu", sample_thread_ids[0], sample_thread_ids[1], sample_thread_ids[2]);
    fclose(identity_receipt);
    if (capture_registers) {
        snapshot_thread = CreateThread(NULL, 0, register_worker, NULL, 0, NULL);
        if (!snapshot_thread) return 13;
        if (!await_file(fire_file)) return 14;
    }
    fixture_marker();
    if (!await_file(post_file)) return 9;
    fixture_marker();
    HANDLE threads[2] = {old_thread, new_thread};
    if (WaitForMultipleObjects(2, threads, TRUE, 5000) != WAIT_OBJECT_0) return 10;
    if (capture_registers) {
        if (WaitForSingleObject(snapshot_thread, 20000) != WAIT_OBJECT_0 ||
            !GetExitCodeThread(snapshot_thread, &snapshot_exit_code) ||
            snapshot_exit_code != 0) return 15;
        CloseHandle(snapshot_thread);
    }
    CloseHandle(old_thread); CloseHandle(new_thread);
    int unchanged = original == *(volatile unsigned char *)(void *)&fixture_marker;
    printf("FIXTURE_COMPLETED=%ld CODE_UNCHANGED=%d\n", hits, unchanged);
    return hits == 6 && unchanged ? 0 : 11;
}
