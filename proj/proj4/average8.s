array:				# array of unsigned bit 8 integers
length:				# length of array			
main:
	# Looping through array to calculate its sum, r0 - address, r1 - length, r2 - sum, r3 - average
	andi $r0, $r0, 0		#storing the address of the memory
	lw $r1, 0($r0) 		# loading length from memory location 0
	andi $r2, $r2, 0 	# initialize sum = 0
	jal loopSum

loopSum:
	add $r0, $r0, 1		# array address is updated
	lw $r3, 0($r0)		# get array[i] 
	add $r2, $r2, $r3	# sum += array[i]
	blt $r0, $r1, loopSum	# keep looping if index < length 
	beq $r0, r1, finish

	li $v0, 10		# code will end
	syscall 
.end main 

finish:
	div $r3, $r2, $r1	# ave = sum / length 
	disp $r3, 0
	jr $r3
	
	
