	.text
main:
	la	$a0,n1
	la	$a1,n2
	jal	proc
	jal	swapa	# swapa works correctly, swapb throws error
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swapa:	

swapb:	

# custom procedure to crash buggy swap
proc:	

	.data
n1:	.word	14
n2:	.word	27
