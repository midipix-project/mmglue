.text

.globl ___chkstk_ms
___chkstk_ms:
	ret

.globl __pei386_runtime_relocator
__pei386_runtime_relocator:
	ret

	.section .got$__pei386_runtime_relocator,"r"
	.global __imp___pei386_runtime_relocator
__imp___pei386_runtime_relocator:
	.long	__pei386_runtime_relocator
	.linkonce discard
