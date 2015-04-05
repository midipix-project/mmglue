.section .init
	pop %edx
	pop %ecx
	pop %ebx
	or  %ebx,%eax
	ret

.section .fini
	pop %edx
	pop %ecx
	pop %ebx
	or  %ebx,%eax
	ret
