.text
.globl _pei386_runtime_relocator
_pei386_runtime_relocator:
	ret

.globl _init
_init:
	call .init
	ret

.globl _fini
_fini:
	call .fini
	ret

.section .init
	xor %rax,%rax
	push %rax
	push %rcx
	push %rdx
	nop
	nop

.section .fini
	xor %rax,%rax
	push %rax
	push %rcx
	push %rdx
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
