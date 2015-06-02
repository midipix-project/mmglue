.text
.globl	___longjmp
.globl	__longjmp
.globl	_longjmp

.def ___longjmp; .scl 2; .type 32; .endef
.def __longjmp; .scl 2; .type 32; .endef
.def _longjmp; .scl 2; .type 32; .endef

___longjmp:
__longjmp:
_longjmp:
	test %edx, %edx		# is val zero?
