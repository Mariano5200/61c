main:
jal readi
move $s0, $v0
jal readi
move $s1, $v0
move $a0, $s0
move $a1, $s1
jal gcd
move $a0, $v0
jal puti
j finish
gcd:
addi $sp, $sp, -8
sw $ra, 4($sp)
beq $a1, $0, gcdPrintReturn
bne $a1, $0, gcdContinue
gcdPrintReturn:
move $v0, $a0
jr $ra
gcdContinue:
div $t0, $a0, $a1
move $a0, $a1
mfhi $a1 
jal gcd
lw $ra , 4($sp)
addi $sp, $sp, 8
jr $ra
finish:
li $v0, 10
syscall

puti:
li $v0, 1
syscall
jr $ra

readi:
li $v0, 5
syscall
jr $ra
