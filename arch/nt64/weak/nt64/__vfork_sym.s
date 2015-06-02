	.global vfork
	.def	vfork; .scl 2; .type 32; .endef
vfork:
	jmp __vfork
