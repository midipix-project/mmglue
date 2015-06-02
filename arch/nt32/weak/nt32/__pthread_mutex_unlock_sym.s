	.global _pthread_mutex_unlock
	.def	_pthread_mutex_unlock; .scl 2; .type 32; .endef
_pthread_mutex_unlock:
	jmp	___pthread_mutex_unlock
