	.global pthread_mutex_lock
	.def	pthread_mutex_lock; .scl 2; .type 32; .endef
pthread_mutex_lock:
	jmp	__pthread_mutex_lock
