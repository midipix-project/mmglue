.text
.globl ___cp_begin
.globl ___cp_end
.globl ___cp_cancel
.globl ___syscall_cp_asm

.def ___cp_begin;       .scl 2; .type 32; .endef
.def ___cp_end;         .scl 2; .type 32; .endef
.def ___cp_cancel;      .scl 2; .type 32; .endef
.def ___syscall_cp_asm; .scl 2; .type 32; .endef

___syscall_cp_asm:
___cp_begin:
	mov 	(%ecx),	%ecx	# check content of ptr
	test	%ecx,	%ecx
	jnz	___cp_cancel	# thread is pending cancellation

	jmp	___syscall

___cp_end:
	ret

___cp_cancel:
	jmp	___cancel

        .section .got$___syscall_cp_asm
        .global __imp____syscall_cp_asm
__imp____syscall_cp_asm:
        .long   ___syscall_cp_asm
        .linkonce discard

        .section .got$___cp_begin
        .global __imp____cp_begin
__imp____cp_begin:
        .long   ___cp_begin
        .linkonce discard

        .section .got$___cp_end
        .global __imp____cp_end
__imp____cp_end:
        .long   ___cp_end
        .linkonce discard

        .section .got$___cp_cancel
        .global __imp____cp_cancel
__imp____cp_cancel:
        .long   ___cp_cancel
        .linkonce discard
