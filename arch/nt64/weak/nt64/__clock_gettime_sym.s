	.global clock_gettime
	.def	clock_gettime; .scl 2; .type 32; .endef
clock_gettime:
	jmp	__clock_gettime
