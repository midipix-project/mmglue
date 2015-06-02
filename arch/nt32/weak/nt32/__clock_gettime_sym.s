	.global _clock_gettime
	.def	_clock_gettime; .scl 2; .type 32; .endef
_clock_gettime:
	jmp	___clock_gettime
