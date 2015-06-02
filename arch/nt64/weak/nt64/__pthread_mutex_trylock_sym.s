	.global pthread_mutex_trylock
	.def	pthread_mutex_trylock; .scl 2; .type 32; .endef
pthread_mutex_trylock:
	jmp	__pthread_mutex_trylock
