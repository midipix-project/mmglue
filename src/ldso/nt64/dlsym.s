############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2025  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

.text
.global dlsym

.def dlsym; .scl 2; .type 32; .endef

dlsym:
	movq  (%rsp),%r8  # original return address as third parameter
	jmp   __dlsym

	.section .got$dlsym,"r"
	.global __imp_dlsym
__imp_dlsym:
	.quad     dlsym
	.linkonce discard
