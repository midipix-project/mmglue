.text
.globl	__setjmp
.globl	_setjmp
.globl	setjmp

.def __setjmp; .scl 2; .type 32; .endef
.def _setjmp; .scl 2; .type 32; .endef
.def setjmp; .scl 2; .type 32; .endef

__setjmp:
_setjmp:
setjmp:
	pop  (%rcx)		# return address
	mov  %rsp, 0x08(%rcx)	# caller's stack pointer
	push (%rcx)		# restore own stack pointer

	mov  %rbx, 0x10(%rcx)
	mov  %rbp, 0x18(%rcx)
	mov  %rdi, 0x20(%rcx)
	mov  %rsi, 0x28(%rcx)
	mov  %r12, 0x30(%rcx)
	mov  %r13, 0x38(%rcx)
	mov  %r14, 0x40(%rcx)
	mov  %r15, 0x48(%rcx)

	xor %eax,  %eax
	ret
