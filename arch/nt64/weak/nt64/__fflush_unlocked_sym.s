	.global fflush_unlocked
	.def	fflush_unlocked; .scl 2; .type 32; .endef
fflush_unlocked:
	jmp __fflush_unlocked_impl
