.text
.globl	___sigsetjmp
.globl	_sigsetjmp

.def __sigsetjmp; .scl 2; .type 32; .endef
.def sigsetjmp; .scl 2; .type 32; .endef

___sigsetjmp:
_sigsetjmp:
				# int sigsetjmp(sigjmp_buf jmp_buf, int save_mask);
				#
				# 8(%esp): save_mask
				# 4(%esp): jmp_buf
				# 0(%esp): return address

	movl  8(%esp),%edx	# edx  <-- save_mask
	test  %edx,%edx 	# save signal mask?
	jnz   1f		# yes: save mask
	jmp   ___setjmp		# no:  setjmp

1:
				# typedef unsigned long __jmp_buf[6];
				#
				# typedef struct __jmp_buf_tag {
				#	__jmp_buf __jb;
				#	unsigned long __fl;
				# 	unsigned long __ss[16];
				# }
				#

	movl  4(%esp),%ecx	# ecx  <-- jmp_buf
	popl  36(%ecx) 		# save return address to .__ss[2]
	movl  %ebx,40(%ecx)	# save ebx (arbitrary choice) to .__ss[3]
	movl  %ecx,%ebx		# save pointer to __jmp_buf to ebx

	call  ___setjmp

	pushl 36(%ebx) 		# push previously saved return address
	movl  %ebx,4(%esp) 	# save pointer to __jmp_buf to 4(%esp) (arg 0)
	movl  %eax,8(%esp)	# save setjmp return value to 8(%esp) (arg 1)
	movl  40(%ebx),%ebx	# restore ebx from .__ss[3]


	jmp ___sigsetjmp_tail	# defer to __sigsetjmp_tail


	.section .got$sigsetjmp,"r"
	.global __imp__sigsetjmp
__imp__sigsetjmp:
	.long _sigsetjmp
	.linkonce discard
