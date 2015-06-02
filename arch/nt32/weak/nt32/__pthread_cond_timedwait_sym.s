	.global _pthread_cond_timedwait
	.def	_pthread_cond_timedwait; .scl 2; .type 32; .endef
_pthread_cond_timedwait:
	jmp	___pthread_cond_timedwait
