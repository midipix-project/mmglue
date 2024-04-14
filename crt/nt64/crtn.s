############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

.text

.globl ___chkstk_ms
___chkstk_ms:
	ret

.globl _pei386_runtime_relocator
_pei386_runtime_relocator:
	ret

	.section .got$_pei386_runtime_relocator,"r"
	.global __imp__pei386_runtime_relocator
__imp__pei386_runtime_relocator:
	.quad	_pei386_runtime_relocator
	.linkonce discard
