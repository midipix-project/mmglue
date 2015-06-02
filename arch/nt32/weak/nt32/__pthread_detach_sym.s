	.global _pthread_detach
	.def	_pthread_detach; .scl 2; .type 32; .endef
_pthread_detach:
	jmp ___pthread_detach_impl
