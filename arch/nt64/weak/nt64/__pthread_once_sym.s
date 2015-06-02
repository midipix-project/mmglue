	.global pthread_once
	.def	pthread_once; .scl 2; .type 32; .endef
pthread_once:
	jmp	__pthread_once
