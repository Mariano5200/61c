#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "memory.h"

/* Pointer to simulator memory */
uint8_t *mem = NULL;

/* Called by program loader to initialize memory. */
uint8_t *init_mem() {
  assert (mem == NULL);
  mem = calloc(MEM_SIZE, sizeof(uint8_t)); // allocate zeroed memory
  return mem;
}

/* Returns 1 if memory access is ok, otherwise 0 */
int access_ok(uint32_t mipsaddr, mem_unit_t size) {

  /* TODO YOUR CODE HERE */
  // null and invalid values checkes
  // then check for alignment.
  if (!mipsaddr || !size || mipsaddr < 1 || mipsaddr >= MEM_SIZE || mipsaddr % size != 0) {
    return 0;
  }
  return 1;
}

/* Writes size bytes of value into mips memory at mipsaddr */
void store_mem(uint32_t mipsaddr, mem_unit_t size, uint32_t value) {
  if (!access_ok(mipsaddr, size)) {
    fprintf(stderr, "%s: bad write=%08x\n", __FUNCTION__, mipsaddr);
    exit(0);
  }

  /* TODO YOUR CODE HERE */
  int shift;
  for (shift = 0; shift < size; shift += 1) {
    *(mem + mipsaddr + shift) = (uint8_t)(value & 0xFF); //shift for the next byte in mem.
    value = value >> 8; //get the next bytes of value.
  }

}

/* Returns zero-extended value from mips memory */
uint32_t load_mem(uint32_t mipsaddr, mem_unit_t size) {
  if (!access_ok(mipsaddr, size)) {
    fprintf(stderr, "%s: bad read=%08x\n", __FUNCTION__, mipsaddr);
    exit(0);
  }

  /* TODO YOUR CODE HERE */

  if (size == SIZE_BYTE) {
    return *(uint8_t*)(mem + mipsaddr);
  } else if (size == SIZE_HALF) {
    return *(uint16_t*)(mem + mipsaddr);
  } else { // SIZE_WORD
    return *(uint32_t*)(mem + mipsaddr);
  }
}
