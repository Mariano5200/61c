	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.align	4, 0x90
_main:
Leh_func_begin1:
	pushq	%rbp
Ltmp0:
	movq	%rsp, %rbp
Ltmp1:
	subq	$96, %rsp
Ltmp2:
	movabsq	$4607182418800017408, %rax
	movq	%rax, -32(%rbp)
	movabsq	$4611686018427387904, %rax
	movq	%rax, -24(%rbp)
	movabsq	$4613937818241073152, %rcx
	movq	%rcx, -16(%rbp)
	movabsq	$4616189618054758400, %rdx
	movq	%rdx, -8(%rbp)
	movq	%rcx, -64(%rbp)
	movq	$0, -56(%rbp)
	movq	$0, -48(%rbp)
	movq	%rax, -40(%rbp)
	pxor	%xmm0, %xmm0
	movaps	%xmm0, -80(%rbp)
	xorl	%eax, %eax
	movaps	%xmm0, -96(%rbp)
	.align	4, 0x90
LBB1_1:
	movupd	-32(%rbp,%rax,2), %xmm0
	movddup	-64(%rbp,%rax), %xmm1
	mulpd	%xmm0, %xmm1
	movapd	-96(%rbp), %xmm2
	addpd	%xmm1, %xmm2
	movapd	%xmm2, -96(%rbp)
	movddup	-48(%rbp,%rax), %xmm1
	mulpd	%xmm0, %xmm1
	movapd	-80(%rbp), %xmm0
	addpd	%xmm1, %xmm0
	movapd	%xmm0, -80(%rbp)
	addq	$8, %rax
	cmpq	$16, %rax
	jne	LBB1_1
	movd	%xmm0, %rax
	movd	%rax, %xmm5
	movd	%xmm2, %rax
	movd	%rax, %xmm4
	movsd	-64(%rbp), %xmm2
	movsd	-48(%rbp), %xmm3
	movsd	-32(%rbp), %xmm0
	movsd	-16(%rbp), %xmm1
	leaq	L_.str(%rip), %rdi
	movb	$6, %al
	callq	_printf
	movdqa	-80(%rbp), %xmm0
	punpckhqdq	%xmm0, %xmm0
	movdqa	%xmm0, -80(%rbp)
	movd	%xmm0, %rax
	movd	%rax, %xmm5
	movdqa	-96(%rbp), %xmm0
	punpckhqdq	%xmm0, %xmm0
	movdqa	%xmm0, -96(%rbp)
	movd	%xmm0, %rax
	movd	%rax, %xmm4
	movsd	-56(%rbp), %xmm2
	movsd	-40(%rbp), %xmm3
	movsd	-24(%rbp), %xmm0
	movsd	-8(%rbp), %xmm1
	leaq	L_.str1(%rip), %rdi
	movb	$6, %al
	callq	_printf
	xorl	%eax, %eax
	addq	$96, %rsp
	popq	%rbp
	ret
Leh_func_end1:

	.section	__TEXT,__const
	.align	5
_C.17.6001:
	.quad	4607182418800017408
	.quad	4611686018427387904
	.quad	4613937818241073152
	.quad	4616189618054758400

	.align	5
_C.18.6002:
	.quad	4613937818241073152
	.quad	0
	.quad	0
	.quad	4611686018427387904

	.section	__TEXT,__cstring,cstring_literals
L_.str:
	.asciz	 "|%g %g| * |%g %g| = |%g %g|\n"

L_.str1:
	.asciz	 "|%g %g|   |%g %g|   |%g %g|\n"

	.section	__TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame0:
Lsection_eh_frame:
Leh_frame_common:
Lset0 = Leh_frame_common_end-Leh_frame_common_begin
	.long	Lset0
Leh_frame_common_begin:
	.long	0
	.byte	1
	.asciz	 "zR"
	.byte	1
	.byte	120
	.byte	16
	.byte	1
	.byte	16
	.byte	12
	.byte	7
	.byte	8
	.byte	144
	.byte	1
	.align	3
Leh_frame_common_end:
	.globl	_main.eh
_main.eh:
Lset1 = Leh_frame_end1-Leh_frame_begin1
	.long	Lset1
Leh_frame_begin1:
Lset2 = Leh_frame_begin1-Leh_frame_common
	.long	Lset2
Ltmp3:
	.quad	Leh_func_begin1-Ltmp3
Lset3 = Leh_func_end1-Leh_func_begin1
	.quad	Lset3
	.byte	0
	.byte	4
Lset4 = Ltmp0-Leh_func_begin1
	.long	Lset4
	.byte	14
	.byte	16
	.byte	134
	.byte	2
	.byte	4
Lset5 = Ltmp1-Ltmp0
	.long	Lset5
	.byte	13
	.byte	6
	.align	3
Leh_frame_end1:


.subsections_via_symbols
