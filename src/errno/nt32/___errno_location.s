############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

.text

.global ____errno_location

.def ____errno_location; .scl 2; .type 32; .endef

____errno_location:
	jmp	___errno_location
