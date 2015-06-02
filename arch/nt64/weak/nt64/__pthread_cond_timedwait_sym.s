	.global pthread_cond_timedwait
	.def	pthread_cond_timedwait; .scl 2; .type 32; .endef
pthread_cond_timedwait:
	jmp	__pthread_cond_timedwait
