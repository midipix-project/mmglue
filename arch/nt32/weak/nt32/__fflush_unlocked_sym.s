	.global _fflush_unlocked
	.def	_fflush_unlocked; .scl 2; .type 32; .endef
_fflush_unlocked:
	jmp ___fflush_unlocked_impl
