.text
.globl __pei386_runtime_relocator
__pei386_runtime_relocator:
	ret

.globl __init
__init:
	call .init
	ret

.globl __fini
__fini:
	call .fini
	ret

.section .init
	xor %eax,%eax
	push %eax
	push %ecx
	push %edx
	nop
	nop

.section .fini
	xor %eax,%eax
	push %eax
	push %ecx
	push %edx
	nop
	nop

.section .midipix
	.ascii "e35ed272"
	.ascii "9e55"
	.ascii "46c1"
	.ascii "8251"
	.ascii "022a59e6c480"
	.long  0
	.long  1
	.long  0
	.long  0
