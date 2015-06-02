	.global sigaction
	.def	sigaction; .scl 2; .type 32; .endef
sigaction:
	jmp	__sigaction
