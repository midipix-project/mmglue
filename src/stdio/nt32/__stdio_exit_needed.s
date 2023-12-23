############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

.text

.def ___stdio_exit_needed; .scl 2; .type 32; .endef

.globl	___stdio_exit_needed

___stdio_exit_needed:
	jmp ___stdio_exit
