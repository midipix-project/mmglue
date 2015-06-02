	.global _pthread_getspecific
	.def	_pthread_getspecific; .scl 2; .type 32; .endef
_pthread_getspecific:
	jmp	___pthread_getspecific_impl

