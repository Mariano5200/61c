	.data
# Do not modify the following linked list
L9: 	.word 23 0
L7: 	.word 100 L8
L6: 	.word 43 L7
L5: 	.word 24 L6
L8: 	.word 21 L9
L3: 	.word 15 L4
L4: 	.word 43 L5
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
    addiu   $sp, $sp -8
    sw        $t1, 0($s1)        # 
    sw        $t1, 0($s1)        # 
    beq     $t1, $0, done    # if $t1 == $0 then done
    
    
	jr $ra
    
done: