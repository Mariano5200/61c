#include <stdio.h>
#include <stdlib.h>

int pairCount(unsigned int n);

int main(int argc, char *argv[]) {
    const char testStr[] = "# pairs in base 2 of %u = %d, should be %d\n";
    if (argc == 2) {
      unsigned int inp = atoi(argv[1]);
      printf ("%d\n", pairCount(inp));
      return 0;
    } else if (argc > 2) {
      printf ("too many arguments!\n");
      return 0;
    }
    printf (testStr, 0, pairCount (0), 0);
    printf (testStr, 11, pairCount (11), 1);
    printf (testStr, 2863377066u, pairCount (2863377066u), 2);
    printf (testStr, 268435456, pairCount (268435456), 0);
    printf (testStr, 4294705151u, pairCount (4294705151u), 29);
    return 0;
}

// Use << or >>
int pairCountBitWise(unsigned int n) {
  // int len = sizeof(n);
  int elevCount = 0;
  // int curr = 0;
  // use a for-loop and bit shift the number.
  // for(int i = 0; i < len; i += 1) {}
  return elevCount;
}

// Use Div by 2 algo to convert to binary.
int pairCount(unsigned int n) {
  // printf("Int passed through: %u\n", n);
  int elevCount, remainprev, remaincurr = 0;
  while (n > 0) {
    remainprev = remaincurr;
    remaincurr = n % 2;
    n /= 2;
    elevCount += ((remaincurr == 1) & (remainprev == 1)) ? 1 : 0;
  }
  return elevCount;
}