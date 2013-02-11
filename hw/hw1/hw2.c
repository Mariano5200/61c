// C proj to test hw1 2a.

int main(int argc, char *argv[]) {
    const char testStr[] = "x %c %d should be %d\n";
    int x = 0;
    printf("For x = 0\n");
    printf(testStr, '&', 0, x & 0);
    printf(testStr, '&', 1, x & 1);
    printf(testStr, '|', 0, x | 0);
    printf(testStr, '|', 1, x | 1);
    printf(testStr, '^', 0, x ^ 0);
    printf(testStr, '^', 1, x ^ 1);
    x = 1;
    printf("For x = 1\n");
    printf(testStr, '&', 0, x & 0);
    printf(testStr, '&', 1, x & 1);
    printf(testStr, '|', 0, x | 0);
    printf(testStr, '|', 1, x | 1);
    printf(testStr, '^', 0, x ^ 0);
    printf(testStr, '^', 1, x ^ 1);
    return 0;
}