	.global vsyslog
	.def	vsyslog; .scl 2; .type 32; .endef
vsyslog:
	jmp __vsyslog
