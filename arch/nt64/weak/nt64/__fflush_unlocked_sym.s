.global fflush_unlocked
fflush_unlocked:
	jmp __fflush_unlocked_impl
