/* Disposable process only: no WeChat APIs, files, networking or injection. */
#include <windows.h>
#include <stdio.h>

static volatile int hits = 0;
__attribute__((noinline)) void fixture_marker(void) { hits++; }

int main(void) {
    for (int i = 0; i < 3; ++i) {
        Sleep(250);
        fixture_marker();
    }
    printf("FIXTURE_COMPLETED=%d\n", hits);
    return hits == 3 ? 0 : 1;
}
