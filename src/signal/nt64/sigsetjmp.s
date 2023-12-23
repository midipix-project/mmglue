############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

.text
.globl	__sigsetjmp
.globl	sigsetjmp

.def __sigsetjmp; .scl 2; .type 32; .endef
.def sigsetjmp; .scl 2; .type 32; .endef

__sigsetjmp:
sigsetjmp:
	test  %edx,%edx		# save signal mask?
	jnz   1f		# yes: save mask
	jmp   setjmp		# no:  setjmp

1:
				# typedef unsigned long __jmp_buf[10];
				#
				# typedef struct __jmp_buf_tag {
				#	__jmp_buf __jb;
				#	unsigned long __fl;
				# 	unsigned long __ss[16];
				# }
				#

	popq  0x68(%rcx) 	# save return address to .__ss[2]
	movq  %rbx,0x70(%rcx)	# save rbx (arbitrary choice) to .__ss[3]
	movq  %rcx,%rbx		# save pointer to __jmp_buf to rbx

	call  __setjmp

	pushq 0x68(%rbx) 	# push previously saved return address
	movq  %rbx,%rcx 	# save pointer to __jmp_buf to rcx (arg 0)
	movl  %eax,%edx		# save setjmp return value to rdx (arg 1)
	movq  0x70(%rcx),%rbx	# restore rbx from .__ss[3]


	jmp __sigsetjmp_tail	# defer to __sigsetjmp_tail


	.section .got$sigsetjmp,"r"
	.global __imp_sigsetjmp
__imp_sigsetjmp:
	.quad	sigsetjmp
	.linkonce discard
