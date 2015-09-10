.text
.global	___syscall
.def	___syscall; .scl 2; .type 32; .endef

___syscall:
	jmp	___syscall_disp

        .section .got$___syscall
        .global __imp____syscall
__imp____syscall:
        .long   ___syscall
        .linkonce discard

