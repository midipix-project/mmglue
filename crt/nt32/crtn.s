.text
.globl _pei386_runtime_relocator
_pei386_runtime_relocator:
	ret

	.section .got$_pei386_runtime_relocator,"r"
	.global __imp__pei386_runtime_relocator
__imp__pei386_runtime_relocator:
	.long	_pei386_runtime_relocator
	.linkonce discard
