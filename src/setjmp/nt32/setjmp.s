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
	pop  (%ecx)		# return address
	mov  %esp, 0x04(%ecx)	# caller's stack pointer
	push (%ecx)		# restore own stack pointer

	xor %eax,  %eax
	ret
