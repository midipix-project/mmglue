.global _fflush_unlocked
_fflush_unlocked:
	jmp ___fflush_unlocked_impl
