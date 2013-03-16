	.file	"hw3_1.c"
	.text
.Ltext0:
	.globl	findMin
	.type	findMin, @function
findMin:
.LFB0:
	.file 1 "hw3_1.c"
	.loc 1 15 0
	.cfi_startproc
	pushq	%rbp
.LCFI0:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
.LCFI1:
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	.loc 1 16 0
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	jne	.L2
	.loc 1 17 0
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	jmp	.L3
.L2:
.LBB2:
	.loc 1 19 0
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	findMin
	movl	%eax, -4(%rbp)
	.loc 1 20 0
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	cmpl	-4(%rbp), %eax
	jle	.L4
	.loc 1 21 0
	movl	-4(%rbp), %eax
	jmp	.L3
.L4:
	.loc 1 23 0
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
.L3:
.LBE2:
	.loc 1 25 0
	leave
.LCFI2:
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	findMin, .-findMin
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0xc7
	.value	0x2
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF2
	.byte	0x1
	.long	.LASF3
	.long	.LASF4
	.quad	.Ltext0
	.quad	.Letext0
	.long	.Ldebug_line0
	.long	.Ldebug_macinfo0
	.uleb128 0x2
	.long	.LASF5
	.byte	0x10
	.byte	0x1
	.byte	0x8
	.long	0x5a
	.uleb128 0x3
	.long	.LASF0
	.byte	0x1
	.byte	0x9
	.long	0x5a
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x3
	.long	.LASF1
	.byte	0x1
	.byte	0xa
	.long	0x61
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x5
	.byte	0x8
	.long	0x31
	.uleb128 0x6
	.long	.LASF5
	.byte	0x1
	.byte	0xb
	.long	0x31
	.uleb128 0x7
	.byte	0x1
	.long	.LASF6
	.byte	0x1
	.byte	0xf
	.byte	0x1
	.long	0x5a
	.quad	.LFB0
	.quad	.LFE0
	.long	.LLST0
	.long	0xc4
	.uleb128 0x8
	.string	"x"
	.byte	0x1
	.byte	0xf
	.long	0xc4
	.byte	0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x9
	.quad	.LBB2
	.quad	.LBE2
	.uleb128 0xa
	.string	"min"
	.byte	0x1
	.byte	0x13
	.long	0x5a
	.byte	0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.uleb128 0x5
	.byte	0x8
	.long	0x67
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.uleb128 0x43
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST0:
	.quad	.LFB0-.Ltext0
	.quad	.LCFI0-.Ltext0
	.value	0x2
	.byte	0x77
	.sleb128 8
	.quad	.LCFI0-.Ltext0
	.quad	.LCFI1-.Ltext0
	.value	0x2
	.byte	0x77
	.sleb128 16
	.quad	.LCFI1-.Ltext0
	.quad	.LCFI2-.Ltext0
	.value	0x2
	.byte	0x76
	.sleb128 16
	.quad	.LCFI2-.Ltext0
	.quad	.LFE0-.Ltext0
	.value	0x2
	.byte	0x77
	.sleb128 8
	.quad	0
	.quad	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_macinfo,"",@progbits
.Ldebug_macinfo0:
	.byte	0x1
	.uleb128 0
	.string	"__STDC__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__STDC_VERSION__ 199901L"
	.byte	0x1
	.uleb128 0
	.string	"__STDC_HOSTED__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__GNUC__ 4"
	.byte	0x1
	.uleb128 0
	.string	"__GNUC_MINOR__ 6"
	.byte	0x1
	.uleb128 0
	.string	"__GNUC_PATCHLEVEL__ 3"
	.byte	0x1
	.uleb128 0
	.string	"__VERSION__ \"4.6.3\""
	.byte	0x1
	.uleb128 0
	.string	"__FINITE_MATH_ONLY__ 0"
	.byte	0x1
	.uleb128 0
	.string	"_LP64 1"
	.byte	0x1
	.uleb128 0
	.string	"__LP64__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_INT__ 4"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_LONG__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_LONG_LONG__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_SHORT__ 2"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_FLOAT__ 4"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_DOUBLE__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_LONG_DOUBLE__ 16"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_SIZE_T__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__CHAR_BIT__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__BIGGEST_ALIGNMENT__ 16"
	.byte	0x1
	.uleb128 0
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
	.byte	0x1
	.uleb128 0
	.string	"__ORDER_BIG_ENDIAN__ 4321"
	.byte	0x1
	.uleb128 0
	.string	"__ORDER_PDP_ENDIAN__ 3412"
	.byte	0x1
	.uleb128 0
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
	.byte	0x1
	.uleb128 0
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_POINTER__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__SIZE_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__PTRDIFF_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__WCHAR_TYPE__ int"
	.byte	0x1
	.uleb128 0
	.string	"__WINT_TYPE__ unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__INTMAX_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__UINTMAX_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__CHAR16_TYPE__ short unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__CHAR32_TYPE__ unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__SIG_ATOMIC_TYPE__ int"
	.byte	0x1
	.uleb128 0
	.string	"__INT8_TYPE__ signed char"
	.byte	0x1
	.uleb128 0
	.string	"__INT16_TYPE__ short int"
	.byte	0x1
	.uleb128 0
	.string	"__INT32_TYPE__ int"
	.byte	0x1
	.uleb128 0
	.string	"__INT64_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT8_TYPE__ unsigned char"
	.byte	0x1
	.uleb128 0
	.string	"__UINT16_TYPE__ short unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT32_TYPE__ unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT64_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST8_TYPE__ signed char"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST16_TYPE__ short int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST32_TYPE__ int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST64_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST64_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST8_TYPE__ signed char"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST16_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST32_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST64_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST8_TYPE__ unsigned char"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST16_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST32_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST64_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__INTPTR_TYPE__ long int"
	.byte	0x1
	.uleb128 0
	.string	"__UINTPTR_TYPE__ long unsigned int"
	.byte	0x1
	.uleb128 0
	.string	"__GXX_ABI_VERSION 1002"
	.byte	0x1
	.uleb128 0
	.string	"__SCHAR_MAX__ 127"
	.byte	0x1
	.uleb128 0
	.string	"__SHRT_MAX__ 32767"
	.byte	0x1
	.uleb128 0
	.string	"__INT_MAX__ 2147483647"
	.byte	0x1
	.uleb128 0
	.string	"__LONG_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
	.byte	0x1
	.uleb128 0
	.string	"__WCHAR_MAX__ 2147483647"
	.byte	0x1
	.uleb128 0
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
	.byte	0x1
	.uleb128 0
	.string	"__WINT_MAX__ 4294967295U"
	.byte	0x1
	.uleb128 0
	.string	"__WINT_MIN__ 0U"
	.byte	0x1
	.uleb128 0
	.string	"__PTRDIFF_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__SIZE_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__INTMAX_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__INTMAX_C(c) c ## L"
	.byte	0x1
	.uleb128 0
	.string	"__UINTMAX_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__UINTMAX_C(c) c ## UL"
	.byte	0x1
	.uleb128 0
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
	.byte	0x1
	.uleb128 0
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
	.byte	0x1
	.uleb128 0
	.string	"__INT8_MAX__ 127"
	.byte	0x1
	.uleb128 0
	.string	"__INT16_MAX__ 32767"
	.byte	0x1
	.uleb128 0
	.string	"__INT32_MAX__ 2147483647"
	.byte	0x1
	.uleb128 0
	.string	"__INT64_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__UINT8_MAX__ 255"
	.byte	0x1
	.uleb128 0
	.string	"__UINT16_MAX__ 65535"
	.byte	0x1
	.uleb128 0
	.string	"__UINT32_MAX__ 4294967295U"
	.byte	0x1
	.uleb128 0
	.string	"__UINT64_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST8_MAX__ 127"
	.byte	0x1
	.uleb128 0
	.string	"__INT8_C(c) c"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST16_MAX__ 32767"
	.byte	0x1
	.uleb128 0
	.string	"__INT16_C(c) c"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST32_MAX__ 2147483647"
	.byte	0x1
	.uleb128 0
	.string	"__INT32_C(c) c"
	.byte	0x1
	.uleb128 0
	.string	"__INT_LEAST64_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__INT64_C(c) c ## L"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST8_MAX__ 255"
	.byte	0x1
	.uleb128 0
	.string	"__UINT8_C(c) c"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST16_MAX__ 65535"
	.byte	0x1
	.uleb128 0
	.string	"__UINT16_C(c) c"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
	.byte	0x1
	.uleb128 0
	.string	"__UINT32_C(c) c ## U"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__UINT64_C(c) c ## UL"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST8_MAX__ 127"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST16_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST32_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__INT_FAST64_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST8_MAX__ 255"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST16_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST32_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__UINT_FAST64_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__INTPTR_MAX__ 9223372036854775807L"
	.byte	0x1
	.uleb128 0
	.string	"__UINTPTR_MAX__ 18446744073709551615UL"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_EVAL_METHOD__ 0"
	.byte	0x1
	.uleb128 0
	.string	"__DEC_EVAL_METHOD__ 2"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_RADIX__ 2"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MANT_DIG__ 24"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_DIG__ 6"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MIN_EXP__ (-125)"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MIN_10_EXP__ (-37)"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MAX_EXP__ 128"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MAX_10_EXP__ 38"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_DECIMAL_DIG__ 9"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_HAS_DENORM__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_HAS_INFINITY__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__FLT_HAS_QUIET_NAN__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MANT_DIG__ 53"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_DIG__ 15"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MIN_EXP__ (-1021)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MIN_10_EXP__ (-307)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MAX_EXP__ 1024"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MAX_10_EXP__ 308"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_DECIMAL_DIG__ 17"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_HAS_DENORM__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_HAS_INFINITY__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__DBL_HAS_QUIET_NAN__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MANT_DIG__ 64"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_DIG__ 18"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MIN_EXP__ (-16381)"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MAX_EXP__ 16384"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MAX_10_EXP__ 4932"
	.byte	0x1
	.uleb128 0
	.string	"__DECIMAL_DIG__ 21"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_HAS_DENORM__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_HAS_INFINITY__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_MANT_DIG__ 7"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_MIN_EXP__ (-94)"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_MAX_EXP__ 97"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_MIN__ 1E-95DF"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_MAX__ 9.999999E96DF"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_EPSILON__ 1E-6DF"
	.byte	0x1
	.uleb128 0
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_MANT_DIG__ 16"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_MIN_EXP__ (-382)"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_MAX_EXP__ 385"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_MIN__ 1E-383DD"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_EPSILON__ 1E-15DD"
	.byte	0x1
	.uleb128 0
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_MANT_DIG__ 34"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_MIN_EXP__ (-6142)"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_MAX_EXP__ 6145"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_MIN__ 1E-6143DL"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_EPSILON__ 1E-33DL"
	.byte	0x1
	.uleb128 0
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
	.byte	0x1
	.uleb128 0
	.string	"__REGISTER_PREFIX__ "
	.byte	0x1
	.uleb128 0
	.string	"__USER_LABEL_PREFIX__ "
	.byte	0x1
	.uleb128 0
	.string	"_FORTIFY_SOURCE 2"
	.byte	0x1
	.uleb128 0
	.string	"__GNUC_STDC_INLINE__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__NO_INLINE__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__STRICT_ANSI__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
	.byte	0x1
	.uleb128 0
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
	.byte	0x1
	.uleb128 0
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
	.byte	0x1
	.uleb128 0
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
	.byte	0x1
	.uleb128 0
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
	.byte	0x1
	.uleb128 0
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
	.byte	0x1
	.uleb128 0
	.string	"__SSP__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_INT128__ 16"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_WCHAR_T__ 4"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_WINT_T__ 4"
	.byte	0x1
	.uleb128 0
	.string	"__SIZEOF_PTRDIFF_T__ 8"
	.byte	0x1
	.uleb128 0
	.string	"__amd64 1"
	.byte	0x1
	.uleb128 0
	.string	"__amd64__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__x86_64 1"
	.byte	0x1
	.uleb128 0
	.string	"__x86_64__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__k8 1"
	.byte	0x1
	.uleb128 0
	.string	"__k8__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__MMX__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SSE__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SSE2__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SSE_MATH__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__SSE2_MATH__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__gnu_linux__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__linux 1"
	.byte	0x1
	.uleb128 0
	.string	"__linux__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__unix 1"
	.byte	0x1
	.uleb128 0
	.string	"__unix__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__ELF__ 1"
	.byte	0x1
	.uleb128 0
	.string	"__DECIMAL_BID_FORMAT__ 1"
	.byte	0x3
	.uleb128 0
	.uleb128 0x1
	.byte	0x4
	.byte	0
	.section	.debug_str,"MS",@progbits,1
.LASF1:
	.string	"next"
.LASF2:
	.string	"GNU C 4.6.3"
.LASF3:
	.string	"hw3_1.c"
.LASF4:
	.string	"/home/cc/cs61c/sp13/class/cs61c-mx/61c/hw/hw3"
.LASF0:
	.string	"value"
.LASF6:
	.string	"findMin"
.LASF5:
	.string	"node"
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
