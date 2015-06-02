	.global pthread_join
	.def	pthread_join; .scl 2; .type 32; .endef
pthread_join:
	jmp __pthread_join
