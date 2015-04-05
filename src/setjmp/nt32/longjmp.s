.text
.globl	___longjmp
.globl	__longjmp
.globl	_longjmp

___longjmp:
__longjmp:
_longjmp:
	test %edx, %edx		# is val zero?
