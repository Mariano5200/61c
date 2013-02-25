#include <stdio.h>
#include <stdint.h>

#include "memory.c"

void test_access();
void load_store_test();

int main() {
  printf("Hex Test: %d\n", 0xFF == 0x000000FF);
  test_access();
  load_store_test();
  return 0;
}

void test_access() {
  int t1 = access_ok(100, 4); // 1
  int t2 = access_ok(100, 1); // 1
  int t3 = access_ok(101, 4); // 0
  int t4 = access_ok(1024*1025, 4); // 0
  int t5 = access_ok(100, 2); // 1
  int t6 = access_ok(101, 2); // 0
  int t7 = access_ok(0, 4); // 0
  int t8 = access_ok(-1, 4); // 0
  int t9 = access_ok(10001, 1); // 1
  int t0 = access_ok(1004, 4); // 1
  printf("Test %d should be %d is: %d\n", 1, 1, t1);
  printf("Test %d should be %d is: %d\n", 2, 1, t2);
  printf("Test %d should be %d is: %d\n", 3, 0, t3);
  printf("Test %d should be %d is: %d\n", 4, 0, t4);
  printf("Test %d should be %d is: %d\n", 5, 1, t5);
  printf("Test %d should be %d is: %d\n", 6, 0, t6);
  printf("Test %d should be %d is: %d\n", 7, 0, t7);
  printf("Test %d should be %d is: %d\n", 8, 0, t8);
  printf("Test %d should be %d is: %d\n", 9, 1, t9);
  printf("Test %d should be %d is: %d\n", 0, 1, t0);
}

void load_store_test() {
  init_mem();
  // store 2 at 104, as a word.
  store_mem(104, SIZE_WORD, 2);
  printf("Loading Word from 104 = 2; %d\n", load_mem(104, SIZE_WORD));
  printf("Loading Half from 104 = 2; %d\n", load_mem(104, SIZE_HALF));
  printf("Loading Byte from 104 = 2; %d\n", load_mem(104, SIZE_BYTE));
  store_mem(105, SIZE_BYTE, 3); // should this error?
  printf("Loading Byte from 104 = 2; %d\n", load_mem(104, SIZE_BYTE));
  printf("Loading Byte from 105 = 3; %d\n", load_mem(105, SIZE_BYTE));
  printf("Loading Word from 104 = 770?; %d\n", load_mem(104, SIZE_WORD));
  store_mem(108, SIZE_WORD, 0x12345678);
  printf("Loading Word from 108 = 12345678; %08x\n", load_mem(108, SIZE_WORD));
  store_mem(112, SIZE_WORD, -123456);
  printf("Loading Word from 112 = -123456; %d\n", load_mem(112, SIZE_WORD));
  store_mem(116, SIZE_WORD, -0xF);
  printf("Loading Word from 116 = -15; %d\n", load_mem(116, SIZE_WORD));



} 