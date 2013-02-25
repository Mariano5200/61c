#include <stdio.h>
#include <stdlib.h>

#include "processor.h"
#include "disassemble.h"

#define signExt(x) ((int32_t) ((int16_t) x))

// #define signExt(x) (x)

void execute_one_inst(processor_t* p, int prompt, int print_regs)
{
  inst_t inst;

  /* fetch an instruction */
  inst.bits = load_mem(p->pc, SIZE_WORD);

  /* interactive-mode prompt */
  if(prompt)
  {
    if (prompt == 1) {
      printf("simulator paused, enter to continue...");
      while(getchar() != '\n')
        ;
    }
    printf("%08x: ",p->pc);
    disassemble(inst);
  }

  switch (inst.rtype.opcode) { /* could also use e.g. inst.itype.opcode */
  
  case 0x0: // opcode == 0x0 (SPECIAL)
    switch (inst.rtype.funct) {
    case 0x0: // funct == 0x0 (sll)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rt] << inst.rtype.shamt;
      p->pc += 4;
      break;

    case 0x2: // funct == 0x2 (srl)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rt] >> inst.rtype.shamt;
      p->pc += 4;
      break;

    case 0x3: // funct == 0x3 (sra) RT SIGN?!
      p->R[inst.rtype.rd] = ((int32_t) p->R[inst.rtype.rt]) >> inst.rtype.shamt;
      p->pc += 4;
      break;

    case 0x8: // funct == 0x8 (jr)
      p->pc = p->R[inst.rtype.rs];
      break;

    case 0x9: // funct == 0x9 (jalr)
      ;
      int tmp = p->pc + 4;
      p->pc = p->R[inst.rtype.rs];
      p->R[inst.rtype.rd] = tmp;
      break;

    case 0xc: // funct == 0xc (SYSCALL)
      handle_syscall(p);
      p->pc += 4;
      break;

    case 0x10: // funct == 0x10 (mfhi)
      p->R[inst.rtype.rd] = p->RHI;
      p->pc += 4;
      break;

    case 0x12: // funct == 0x12 (mflo)
      p->R[inst.rtype.rd] = p->RLO;
      p->pc += 4;
      break;

    case 0x18: //fall through for multu == mult.
    case 0x19: // funct == 0x18 (mult)
      perform_mult(p->R[inst.rtype.rs], p->R[inst.rtype.rt], &p->RLO, &p->RHI);
      p->pc += 4;
      break;

    case 0x21: // funct == 0x21 (addu)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] + p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x23: // funct == 0x23 (subu)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] - p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x24: // funct == 0x24 (AND)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] & p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x25: // funct == 0x25 (OR)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] | p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x26: // funct == 0x26 (XOR)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] ^ p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x27: // funct == 0x27 (NOR)
      p->R[inst.rtype.rd] = ~(p->R[inst.rtype.rs] | p->R[inst.rtype.rt]);
      p->pc += 4;
      break;

    case 0x2a: // funct == 0x2a (SLT) SIGNED? RS RT
      p->R[inst.rtype.rd] = ((int32_t)p->R[inst.rtype.rs] < (int32_t)p->R[inst.rtype.rt]);
      p->pc += 4;
      break;

    case 0x2b: // funct == 0x2b (sltu)
      p->R[inst.rtype.rd] = (p->R[inst.rtype.rs] < p->R[inst.rtype.rt]);
      p->pc += 4;
      break;

    default: // undefined funct
      fprintf(stderr, "%s: pc=%08x, illegal instruction=%08x\n", __FUNCTION__, p->pc, inst.bits);
      exit(-1);
      break;
    }
    break; // END R-TYPE INST.

  case 0x2: // opcode == 0x2 (J)
    p->pc = ((p->pc + 4) & 0xF0000000) | (inst.jtype.addr << 2);
    break;

  case 0x3: // opcode == 0x3 (JAL)
    p->R[31] = p->pc + 4;
    p->pc = ((p->pc + 4) & 0xF0000000) | (inst.jtype.addr << 2);
    break;

  /* BEGIN I-TYPE INSTRS */
  case 0x4: // opcode == 0x4 (BEQ) SIGNEXT.
    p->pc += (p->R[inst.itype.rt] == p->R[inst.itype.rs]) ? 4 + (signExt(inst.itype.imm) << 2) : 4;
    break;

  case 0x5: // opcode == 0x5 (BNE) SIGNEXT
    p->pc += (p->R[inst.itype.rt] != p->R[inst.itype.rs]) ? 4 + (signExt(inst.itype.imm) << 2) : 4;
    break;

  case 0x9: // opcode == 0x9 (ADDIU)  SIGNEXT --Unsiged?
    p->R[inst.itype.rt] = p->R[inst.itype.rs] + (uint32_t) signExt(inst.itype.imm);
    p->pc += 4;
    break;

  case 0xa: // opcode == 0xa (SLTI) SIGNED????, SIGNEXT
    p->R[inst.itype.rt] = ((int32_t) p->R[inst.itype.rs]) < signExt(inst.itype.imm);
    p->pc += 4;
    break;

  case 0xb: // opcode == 0xb (SLTIU) SIGNEXT
    p->R[inst.itype.rt] = (p->R[inst.itype.rs] < signExt(inst.itype.imm));
    p->pc += 4;
    break;

  case 0xc: // opcode == 0xc (ANDI) 0ext
    p->R[inst.itype.rt] = p->R[inst.itype.rs] & inst.itype.imm;
    p->pc += 4;
    break;

  case 0xd: // opcode == 0xd (ORI) (done for us) 0ext
    p->R[inst.itype.rt] = p->R[inst.itype.rs] | inst.itype.imm;
    p->pc += 4;
    break;

  case 0xe: // opcode == 0xe (XOR) 0ext
    p->R[inst.itype.rt] = p->R[inst.itype.rs] ^ inst.itype.imm;
    p->pc += 4;
    break;

  case 0xf: // opcode == 0xf (LUI) SIGNEXT
    p->R[inst.itype.rt] = inst.itype.imm << 16;
    p->pc += 4;
    break;

  case 0x20: // opcode == 0x20 (LB)  SIGNEXT, SIGNEXT ??
    p->R[inst.itype.rt] = (int32_t) (int8_t) load_mem(((int32_t)p->R[inst.itype.rs] + signExt(inst.itype.imm)), SIZE_BYTE);
    p->pc += 4;
    break;

  case 0x23: // opcode == 0x23 (LW) SIGNEXT
    p->R[inst.itype.rt] = load_mem(((int32_t)p->R[inst.itype.rs] + signExt(inst.itype.imm)), SIZE_WORD);
    p->pc += 4;
    break;

  case 0x24: // opcode == 0x24 (LBU) 0ext, SIGNEXT
    p->R[inst.itype.rt] = (uint8_t)(load_mem(((int32_t)p->R[inst.itype.rs] + signExt(inst.itype.imm)), SIZE_BYTE));
    p->pc += 4;
    break;

  case 0x28: // opcode == 0x28 (SB) 0ext
    store_mem(((int32_t)p->R[inst.itype.rs] + signExt(inst.itype.imm)), SIZE_BYTE, p->R[inst.itype.rt]);
    p->pc += 4;
    break;

  case 0x2b: // opcode == 0x2b (SW)  SIGNEXT
    store_mem(((int32_t)p->R[inst.itype.rs] + signExt(inst.itype.imm)), SIZE_WORD, p->R[inst.itype.rt]);
    p->pc += 4;
    break;

  default: // undefined opcode
    fprintf(stderr, "%s: pc=%08x, illegal instruction: %08x\n", __FUNCTION__, p->pc, inst.bits);
    exit(-1);
    break;
  }

  // enforce $0 being hard-wired to 0
  p->R[0] = 0;

  if(print_regs)
    print_registers(p);
}

void perform_mult(reg_t rs, reg_t rt, reg_t *lo, reg_t *hi){
  uint64_t product = ((uint64_t)rs) * rt;
  *lo = product;
  *hi = product >> 32;
}

void init_processor(processor_t* p)
{
  int i;

  /* initialize pc to 0x1000 */
  p->pc = 0x1000;

  /* zero out all registers */
  for (i=0; i<32; i++)
  {
    p->R[i] = 0;
  }

  /* zero out special registers RLO and RHI */
  p->RHI = 0;
  p->RLO = 0;
}

void print_registers(processor_t* p)
{
  int i,j;
  for (i=0; i<8; i++)
  {
    for (j=0; j<4; j++)
      printf("r%2d=%08x ",i*4+j,p->R[i*4+j]);
    puts("");
  }
}

void handle_syscall(processor_t* p)
{
  reg_t i;

  switch (p->R[2]) // syscall number is given by $v0 ($2)
  {
  case 1: // print an integer
    printf("%d", p->R[4]);
    break;

  case 4: // print a string
    for(i = p->R[4]; i < MEM_SIZE && load_mem(i, SIZE_BYTE); i++)
      printf("%c", load_mem(i, SIZE_BYTE));
    break;

  case 10: // exit
    printf("exiting the simulator\n");
    exit(0);
    break;

  case 11: // print a character
    printf("%c", p->R[4]);
    break;

  default: // undefined syscall
    fprintf(stderr, "%s: illegal syscall number %d\n", __FUNCTION__, p->R[2]);
    exit(-1);
    break;
  }
}
