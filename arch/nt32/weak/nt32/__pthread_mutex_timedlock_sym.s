	.global _pthread_mutex_timedlock
	.def	_pthread_mutex_timedlock; .scl 2; .type 32; .endef
_pthread_mutex_timedlock:
	jmp ___pthread_mutex_timedlock
