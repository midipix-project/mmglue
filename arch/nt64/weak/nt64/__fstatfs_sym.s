	.global fstatfs
	.def	fstatfs; .scl 2; .type 32; .endef
fstatfs:
	jmp __fstatfs
