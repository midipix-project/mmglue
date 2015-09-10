.text
.globl	___setjmp
.globl	__setjmp
.globl	_setjmp

.def ___setjmp; .scl 2; .type 32; .endef
.def __setjmp; .scl 2; .type 32; .endef
.def _setjmp; .scl 2; .type 32; .endef

___setjmp:
__setjmp:
_setjmp:
	ret

	.section .got$setjmp,"r"
	.global __imp__setjmp
__imp__setjmp:
	.long	_setjmp
	.linkonce discard
