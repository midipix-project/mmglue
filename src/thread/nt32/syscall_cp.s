.text
.globl	___syscall_cp_asm
.globl	___cp_begin
.globl	___cp_end

___syscall_cp_asm:
___cp_begin:
	mov 	(%ecx),	%ecx	# check content of ptr
	test	%ecx,	%ecx
	jnz	___cancel	# thread is pending cancellation

	jmp	___syscall

___cp_end:
	ret

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
