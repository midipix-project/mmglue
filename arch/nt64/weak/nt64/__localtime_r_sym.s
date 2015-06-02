	.global localtime_r
	.def	localtime_r; .scl 2; .type 32; .endef
localtime_r:
	jmp	__localtime_r
