# Discussion 3

# $s0 < $s1
# 1A
slt $t0, $s0, $s1
bne $t0, $0, label
# 1B
# $s0 <= $s1
slt $t0, $s1, $s0
beq $t0, $0, label

# 1C
# $s0 > 1 !(1 < s0)
addiu $t0, $0, 1
slt $t0, $t0, $s0 #slti has immedate with last pos.
beq $t0, $0, label
# 1D
# $s0 >= 1 !($s0 < 1)
slti $t0, $s0, 1
beq $tr0, $0, label

# FIB

      beq $s0, $0, Ret0
      addi $t2, $0, 1 # ori works
      beq $s0, $t2, Ret1
      addiu $s0, $s0, -2
Loop: beq   $s0, $0, RetF
      addu  $s1, $t0, $t1
      addiu $t0, $t1, 0
      addiu $t1, $s1, 0
      addiu $s0, $s0, -1
      j     Loop
Ret0: addiu $v0, $0, 0
      j     Done
Ret1: addiu $v0, $0, 1
      j     Done
RetF: addu  $v0, $0, $s1
Done: jr    $ra