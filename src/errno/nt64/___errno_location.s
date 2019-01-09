.text

.global ___errno_location

.def ___errno_location; .scl 2; .type 32; .endef

___errno_location:
	jmp	__errno_location
