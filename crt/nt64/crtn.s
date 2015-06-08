.section .init
	pop %rdx
	pop %rcx
	pop %r10
	or  %r10,%rax
	ret

.section .fini
	pop %rdx
	pop %rcx
	pop %r10
	or  %r10,%rax
	ret

	.section .got$_pei386_runtime_relocator,"r"
	.global __imp__pei386_runtime_relocator
__imp__pei386_runtime_relocator:
	.quad	_pei386_runtime_relocator
	.linkonce discard
