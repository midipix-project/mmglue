	.global _pthread_mutex_trylock
	.def	_pthread_mutex_trylock; .scl 2; .type 32; .endef
_pthread_mutex_trylock:
	jmp	___pthread_mutex_trylock
