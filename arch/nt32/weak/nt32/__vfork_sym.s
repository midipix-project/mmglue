	.global _vfork
	.def	_vfork; .scl 2; .type 32; .endef
_vfork:
	jmp ___vfork
