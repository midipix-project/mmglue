.text
.globl __so_entry_point
__so_entry_point:
	cmp	$0x1,%edx
	jne	_dso_main_routine
	mov	%edx,%eax
	ret

___dso_main_routine:
	ret

	.weak	_dso_main_routine
	.def	_dso_main_routine; .scl	2; .type 32; .endef
	.set	_dso_main_routine,___dso_main_routine

.section .midipix
	.long	__so_entry_point
	.long	_dso_main_routine
	.long	0
	.long	0

	# void *reserved[16];
	.long	0x0
	.long	0x1
	.long	0x2
	.long	0x3
	.long	0x4
	.long	0x5
	.long	0x6
	.long	0x7
	.long	0x8
	.long	0x9
	.long	0xa
	.long	0xb
	.long	0xc
	.long	0xd
	.long	0xe
	.long	0xf
