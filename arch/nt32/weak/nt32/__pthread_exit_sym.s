	.global _pthread_exit
	.def	_pthread_exit; .scl 2; .type 32; .endef
_pthread_exit:
	jmp	___pthread_exit
