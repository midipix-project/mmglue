############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

.text
.globl	___longjmp
.globl	__longjmp
.globl	_longjmp

.def ___longjmp; .scl 2; .type 32; .endef
.def __longjmp; .scl 2; .type 32; .endef
.def _longjmp; .scl 2; .type 32; .endef

___longjmp:
__longjmp:
_longjmp:
	movl 4(%esp), %ecx	# jump buffer
	movl 8(%esp), %eax	# val

	test %eax, %eax		# is val zero?
	jne  1f			# no:  return val
	xor  $1,   %eax		# yes: return one

1:
	movl 20(%ecx), %esi	# restore regs
	movl 16(%ecx), %edi
	movl 12(%ecx), %ebp
	movl 8(%ecx),  %ebx

	movl 4(%ecx),  %esp	# original stack pointer

	movl (%ecx),   %edx	# original return address
	jmp  *%edx

	.section .got$longjmp
	.global __imp__longjmp
__imp__longjmp:
	.long	_longjmp
	.linkonce discard
