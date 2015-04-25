# standard dynamic loader is not required
# optional dynamic loader [to be] provided by libldso/libpsxscl

.section .data

.globl ___init_array_start
.globl ___init_array_end
.globl ___fini_array_start
.globl ___fini_array_end

___init_array_start:
	.long  0

___init_array_end:
	.long  0

___fini_array_start:
	.long  0

___fini_array_end:
	.long  0
