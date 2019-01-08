.text
.global __cp_begin
.global __cp_end
.global __cp_cancel
.global __syscall_cp_asm

.def __cp_begin;       .scl 2; .type 32; .endef
.def __cp_end;         .scl 2; .type 32; .endef
.def __cp_cancel;      .scl 2; .type 32; .endef
.def __syscall_cp_asm; .scl 2; .type 32; .endef

__syscall_cp_asm:
__cp_begin:
	movq	(%rcx),	%rcx		# check content of ptr
	test	%ecx,	%ecx
	jnz	__cp_cancel		# thread is pending cancellation

	movq	%rdx,	    %rcx	# move water
	movq	%r8,	    %rdx	# from one glass
	movq	%r9,	    %r8 	# to another
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

__cp_cancel:
	jmp	__cancel


	.section .got$__syscall_cp_asm
	.global __imp___syscall_cp_asm
__imp___syscall_cp_asm:
	.quad __syscall_cp_asm
	.linkonce discard

	.section .got$__cp_begin
	.global __imp___cp_begin
__imp___cp_begin:
	.quad __cp_begin
	.linkonce discard

	.section .got$__cp_end
	.global __imp___cp_end
__imp___cp_end:
	.quad __cp_end
	.linkonce discard

	.section .got$__cp_cancel
	.global __imp___cp_cancel
__imp___cp_cancel:
	.quad __cp_cancel
	.linkonce discard
