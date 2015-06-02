	.global _pthread_mutex_lock
	.def	_pthread_mutex_lock; .scl 2; .type 32; .endef
_pthread_mutex_lock:
	jmp	___pthread_mutex_lock
