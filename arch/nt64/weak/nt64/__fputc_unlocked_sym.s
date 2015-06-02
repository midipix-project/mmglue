	.global fputc_unlocked
	.def	fputc_unlocked; .scl 2; .type 32; .endef
fputc_unlocked:
	jmp putc_unlocked
