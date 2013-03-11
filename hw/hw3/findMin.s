	.data
# Do not modify the following linked list
L9: 	.word 23 0
L8: 	.word 21 L9
L7: 	.word 100 L8
L6: 	.word 43 L7
L5: 	.word 24 L6
L4: 	.word 43 L5
L3: 	.word 15 L4
L2: 	.word -2 L3
L1: 	.word 21 L2
L0: 	.word 20 L1
space:
	.ascii " "

	.text
	la $a0 L8 # find min from node 8
	jal findMin
	move $a0 $v0
	li $v0 1
	syscall

	la $a0 space
	li $v0 4
	syscall

	la $a0 L0 # find min from node 0
	jal findMin
	move $a0 $v0
	li $v0 1
	syscall
	li $v0 10
	syscall

# Your code here
# You must use recursion for full credit
findMin:
    addiu   $sp, $sp, -8
    sw      $ra, 0($sp)       # store $ra on stack
    sw      $a0, 4($sp)       # store a0 on stack
    lw      $t1, 0($a0)        # load a0 into t1
    lw      $t2, 4($a0)       # t2 is x->next
    beq     $t2, $0, done     # if $t2 == $0 then done
    move    $a0, $t2          # x = x->next
    jal     findMin           # recurse
    move    $v0, $t1          # $t1 = $v0
    bge     $a0, $t1, done  # if $s0 < $t1 then done
min:                         # return the current min.
    move     $a0, $t1        # $t0 = $a0
    j        done            # jump to done
done:
    lw      $ra, 0($sp)      # load ra from stack
    lw      $a0, 4($sp)        #
    addiu   $sp, $sp, 8
    lw      $v0 0($a0)         # $v0 = $a0
    jr $ra
