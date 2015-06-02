	.global pthread_detach
	.def	pthread_detach; .scl 2; .type 32; .endef
pthread_detach:
	jmp __pthread_detach_impl
