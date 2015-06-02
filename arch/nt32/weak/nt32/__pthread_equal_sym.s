	.global _pthread_equal
	.def	_pthread_equal; .scl 2; .type 32; .endef
_pthread_equal:
	jmp ___pthread_equal_impl
