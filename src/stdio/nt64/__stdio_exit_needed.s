.text

.def __stdio_exit_needed; .scl 2; .type 32; .endef

.globl	__stdio_exit_needed

__stdio_exit_needed:
	jmp __stdio_exit
