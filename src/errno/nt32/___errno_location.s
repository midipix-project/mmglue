.text

.global ____errno_location

.def ____errno_location; .scl 2; .type 32; .endef

____errno_location:
	jmp	___errno_location
