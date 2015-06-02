	.global pthread_testcancel
	.def	pthread_testcancel; .scl 2; .type 32; .endef
pthread_testcancel:
	jmp	__pthread_testcancel
