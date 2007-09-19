#include <stdio.h>

#ifdef _MSC_VER
void __GSHandlerCheck(void) {}
void __security_check_cookie(void) {}
void __security_cookie(void) {}
#endif

int main(void) {
    printf("DONE\n");
}