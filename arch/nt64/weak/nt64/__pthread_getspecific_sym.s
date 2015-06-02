	.global pthread_getspecific
	.def	pthread_getspecific; .scl 2; .type 32; .endef
pthread_getspecific:
	jmp	__pthread_getspecific_impl

