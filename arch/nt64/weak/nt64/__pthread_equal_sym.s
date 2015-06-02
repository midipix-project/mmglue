	.global pthread_equal
	.def	pthread_equal; .scl 2; .type 32; .endef
pthread_equal:
	jmp __pthread_equal_impl
