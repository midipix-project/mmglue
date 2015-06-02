	.global __stdio_exit_needed
	.def	__stdio_exit_needed; .scl 2; .type 32; .endef
__stdio_exit_needed:
	jmp	__stdio_exit
