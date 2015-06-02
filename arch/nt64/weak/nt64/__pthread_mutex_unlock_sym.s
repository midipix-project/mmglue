	.global pthread_mutex_unlock
	.def	pthread_mutex_unlock; .scl 2; .type 32; .endef
pthread_mutex_unlock:
	jmp	__pthread_mutex_unlock
