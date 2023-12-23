############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

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

	.section .got$setjmp,"r"
	.global __imp_setjmp
__imp_setjmp:
	.quad	setjmp
	.linkonce discard
