	.global tzname
	.def	tzname; .scl 2; .type 32; .endef
tzname:
	jmp __tzname
