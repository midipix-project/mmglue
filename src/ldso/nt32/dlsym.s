############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2025  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

.text
.global _dlsym

.def _dlsym; .scl 2; .type 32; .endef

_dlsym:
	movl  %esp,%ecx  # save stack pointer
	push  (%ecx)     # original return address
	push  12(%ecx)   # original second argument
	push  12(%ecx)   # original first argument
	call  ___dlsym
	movl  %ecx,%esp  # restore stack pointer

	.section .got$_dlsym,"r"
	.global __imp__dlsym
__imp__dlsym:
	.long     _dlsym
	.linkonce discard
