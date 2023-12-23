############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

.text

.global ___errno_location

.def ___errno_location; .scl 2; .type 32; .endef

___errno_location:
	jmp	__errno_location
