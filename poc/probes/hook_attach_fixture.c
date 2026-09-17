/* Own disposable process: old/new threads and calls after debugger detach. */
#include <windows.h>
#include <stdio.h>

static volatile LONG hits = 0;
static char go_file[MAX_PATH], post_file[MAX_PATH];
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
    fixture_marker();
    if (!await_file(post_file)) return 3;
    fixture_marker();
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 2) return 4;
    snprintf(go_file, MAX_PATH, "%s\\go", argv[1]);
    snprintf(post_file, MAX_PATH, "%s\\post", argv[1]);
    unsigned char original = *(volatile unsigned char *)(void *)&fixture_marker;
    HANDLE old_thread = CreateThread(NULL, 0, worker, NULL, 0, NULL);
    if (!old_thread) return 5;
    char ready[MAX_PATH];
    snprintf(ready, MAX_PATH, "%s\\ready", argv[1]);
    FILE *receipt = fopen(ready, "w");
    if (!receipt) return 6;
    fputs("ready", receipt); fclose(receipt);
    if (!await_file(go_file)) return 7;
    HANDLE new_thread = CreateThread(NULL, 0, worker, NULL, 0, NULL);
    if (!new_thread) return 8;
    fixture_marker();
    if (!await_file(post_file)) return 9;
    fixture_marker();
    HANDLE threads[2] = {old_thread, new_thread};
    if (WaitForMultipleObjects(2, threads, TRUE, 5000) != WAIT_OBJECT_0) return 10;
    CloseHandle(old_thread); CloseHandle(new_thread);
    int unchanged = original == *(volatile unsigned char *)(void *)&fixture_marker;
    printf("FIXTURE_COMPLETED=%ld CODE_UNCHANGED=%d\n", hits, unchanged);
    return hits == 6 && unchanged ? 0 : 11;
}
