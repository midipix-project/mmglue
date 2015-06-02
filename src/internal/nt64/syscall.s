.text
.global	__syscall
.def	__syscall; .scl 2; .type 32; .endef

__syscall:
	jmp	__syscall_disp
