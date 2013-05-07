OCTAL:
	lui $r0, 0
	lw $r1, 0($r0)
	sw $r3, 0($r0)
	lui $r2, 0
	or $r2, $r2, $r1
	andi $r2, $r2, 7
	sw $r2, 1($r0)
	or $r2, $r2, $r1
	andi $r2, $r2, 0x38
	lui $r3, 0
	ori $r3, $r3, 1
	sllv $r2, $r2, $r3
	sw $r2, 2($r0)
	addi $r2, $r1, 0
	srlv $r2, $r2, $r3
	andi $r2, $r2, 0xe0
	lui $r3, 0
	ori $r3, $r3, 3
	sllv $r2, $r2, $r3
	lw $r1, 2($r0)
	lw $r3, 1($r0)
	or $r2, $r2, $r1
	or $r2, $r2, $r3
	disp $r2, 0
	lw $r3, 0($r0)
	jr $r3