.text
.globl	__syscall_cp_asm
.globl	__cp_begin
.globl	__cp_end

__syscall_cp_asm:
__cp_begin:
	movq	(%rcx),	%rcx	/* check content of ptr */
	test	%ecx,	%ecx
	jnz	__cancel	/* thread is pending cancellation */

	movq	%rdx,	    %rcx/* move water     */
	movq	%r8,	    %rdx/* from one glass */
	movq	%r9,	    %r8 /* to another     */
	movq	0x28(%rsp), %r9

	movq	0x30(%rsp),%rax
	movq	%rax,	   0x28(%rsp)

	movq	0x38(%rsp),%r10
	movq	%r10,	   0x30(%rsp)

	movq	0x40(%rsp),%r10
	movq	%r10,	   0x38(%rsp)

	jmp	__syscall

__cp_end:
	ret
