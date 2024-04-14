############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

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
	movl 4(%esp), %edx	# jump buffer

	movl (%esp),  %eax	# return address
	movl %eax,    (%edx)

	leal 4(%esp), %ecx	# caller's stack pointer
	movl %ecx,    4(%edx)

	movl %ebx,    8(%edx)
	movl %ebp,    12(%edx)
	movl %edi,    16(%edx)
	movl %esi,    20(%edx)

	xor  %eax,%eax
	ret

	.section .got$setjmp,"r"
	.global __imp__setjmp
__imp__setjmp:
	.long	_setjmp
	.linkonce discard
