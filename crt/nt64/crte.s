.text
.globl _so_entry_point
_so_entry_point:
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
	.quad	dso_main_routine
	.quad	_so_entry_point
	.quad	_init
	.quad	_fini
