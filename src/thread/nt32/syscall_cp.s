.text
.globl	___syscall_cp_asm
.globl	___cp_begin
.globl	___cp_end

___syscall_cp_asm:
___cp_begin:
	mov 	(%ecx),	%ecx	/* check content of ptr */
	test	%ecx,	%ecx
	jnz	___cancel	/* thread is pending cancellation */

	jmp	___syscall

___cp_end:
	ret
