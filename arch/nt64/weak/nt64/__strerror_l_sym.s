	.global strerror_l
	.def	strerror_l; .scl 2; .type 32; .endef
strerror_l:
	jmp __strerror_l
