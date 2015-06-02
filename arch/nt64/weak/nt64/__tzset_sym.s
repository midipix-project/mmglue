	.global tzset
	.def	tzset; .scl 2; .type 32; .endef
tzset:
	jmp __tzset
