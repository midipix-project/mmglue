############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
############################################################################

	.file	"crtend.s"

	.cfi_sections	.debug_frame

	# C
	.section .dsosyms$__gcc_personality_seh0
	.linkonce discard
	.balign 8

	.weak	__imp___gcc_personality_seh0
	.quad   0
	.long   0
	.long   0

	.text
	.def    .__gcc_personality_seh0; .scl 2; .type 32; .endef
	.global .__gcc_personality_seh0

	.cfi_startproc
.__gcc_personality_seh0:
	movq        __imp___gcc_personality_seh0(%rip), %rax
        rex.W jmp   *%rax
	.cfi_endproc



	# C++
	.section .dsosyms$__gxx_personality_seh0
	.linkonce discard
	.balign 8

	.weak	__imp___gxx_personality_seh0
	.quad   0
	.long   0
	.long   0

	.text
	.def    .__gxx_personality_seh0; .scl 2; .type 32; .endef
	.global .__gxx_personality_seh0

	.cfi_startproc
.__gxx_personality_seh0:
	movq        __imp___gxx_personality_seh0(%rip), %rax
        rex.W jmp   *%rax
	.cfi_endproc



	# OBJC
	.section .dsosyms$__gnu_objc_personality_seh0
	.linkonce discard
	.balign 8

	.weak	__imp___gnu_objc_personality_seh0
	.quad   0
	.long   0
	.long   0

	.text
	.def    .__gnu_objc_personality_seh0; .scl 2; .type 32; .endef
	.global .__gnu_objc_personality_seh0

	.cfi_startproc
.__gnu_objc_personality_seh0:
	movq        __imp___gnu_objc_personality_seh0(%rip), %rax
        rex.W jmp   *%rax
	.cfi_endproc

	# DSO REFERENCE COUNTING
	.data
	.global __dso_handle
__dso_handle:
	.long	0

	.section .midipix
	.global  __imp___dso_handle
__imp___dso_handle:
	.quad    __dso_handle
