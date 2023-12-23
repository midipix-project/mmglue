############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

.text

.globl ___chkstk_ms
___chkstk_ms:
	ret

.globl __pei386_runtime_relocator
__pei386_runtime_relocator:
	ret

	.section .got$__pei386_runtime_relocator,"r"
	.global __imp___pei386_runtime_relocator
__imp___pei386_runtime_relocator:
	.long	__pei386_runtime_relocator
	.linkonce discard
