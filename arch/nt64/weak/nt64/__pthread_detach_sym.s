.global pthread_detach
pthread_detach:
	jmp __pthread_detach_impl
