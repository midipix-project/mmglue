	.global _fputc_unlocked
	.def	_fputc_unlocked; .scl 2; .type 32; .endef
_fputc_unlocked:
	jmp _putc_unlocked
