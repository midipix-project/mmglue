	.global pthread_mutex_timedlock
	.def	pthread_mutex_timedlock; .scl 2; .type 32; .endef
pthread_mutex_timedlock:
	jmp __pthread_mutex_timedlock
