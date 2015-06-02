	.global pthread_key_create
	.def	pthread_key_create; .scl 2; .type 32; .endef
pthread_key_create:
	jmp	__pthread_key_create
