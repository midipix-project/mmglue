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
	.long	_dso_main_routine
	.long	__so_entry_point
	.long	__init
	.long	__fini
