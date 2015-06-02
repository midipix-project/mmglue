.text
.global	___syscall
.def	___syscall; .scl 2; .type 32; .endef

___syscall:
	jmp	___syscall_disp
