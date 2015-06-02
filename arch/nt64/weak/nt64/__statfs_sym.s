	.global statfs
	.def	statfs; .scl 2; .type 32; .endef
statfs:
	jmp __statfs
