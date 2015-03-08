.section .init
	pop %rdx
	pop %rcx
	pop %r10
	or  %r10,%rax
	ret

.section .fini
	pop %rdx
	pop %rcx
	pop %r10
	or  %r10,%rax
	ret
