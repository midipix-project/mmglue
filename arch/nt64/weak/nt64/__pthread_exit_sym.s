	.global pthread_exit
	.def	pthread_exit; .scl 2; .type 32; .endef
pthread_exit:
	jmp	__pthread_exit
