.text
.globl __so_entry_point
__so_entry_point:
	cmp	$0x1,%edx
	jne	dso_main_routine
	mov	%edx,%eax
	ret

__dso_main_routine:
	ret

	.weak	dso_main_routine
	.def    dso_main_routine; .scl 2; .type 32; .endef
	.set	dso_main_routine,__dso_main_routine

.section .midipix
	.quad	__so_entry_point
	.quad	dso_main_routine
	.quad	0
	.quad	0

	# void *reserved[16];
	.quad	0x0
	.quad	0x1
	.quad	0x2
	.quad	0x3
	.quad	0x4
	.quad	0x5
	.quad	0x6
	.quad	0x7
	.quad	0x8
	.quad	0x9
	.quad	0xa
	.quad	0xb
	.quad	0xc
	.quad	0xd
	.quad	0xe
	.quad	0xf
