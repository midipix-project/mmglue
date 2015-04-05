.text
.globl	___setjmp
.globl	__setjmp
.globl	_setjmp

___setjmp:
__setjmp:
_setjmp:
	pop  (%ecx)		# return address
	mov  %esp, 0x04(%ecx)	# caller's stack pointer
	push (%ecx)		# restore own stack pointer

	xor %eax,  %eax
	ret
