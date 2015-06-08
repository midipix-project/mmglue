.text
.global	__syscall
.def	__syscall; .scl 2; .type 32; .endef

__syscall:
	jmp	__syscall_disp

	.section .got$__syscall,"r"
	.global __imp___syscall
__imp___syscall:
	.quad	__syscall
	.linkonce discard
