#include <stdio.h>

int pairCount(unsigned int n);

int main(int argc, char *argv[]) {
    const char testStr[] = "# pairs in base 2 of %u = %d, should be %d\n";
    printf (testStr, 0, pairCount (0), 0);
    printf (testStr, 11, pairCount (11), 1);
    printf (testStr, 2863377066u, pairCount (2863377066u), 2);
    printf (testStr, 268435456, pairCount (268435456), 0);
    printf (testStr, 4294705151u, pairCount (4294705151u), 29);
    return 0;
}

int pairCount(unsigned int n) {
}
