# standard dynamic loader is not required
# optional dynamic loader [to be] provided by libldso/libpsxscl

.section .data

.globl __init_array_start
.globl __init_array_end
.globl __fini_array_start
.globl __fini_array_end

__init_array_start:
	.quad  0

__init_array_end:
	.quad  0

__fini_array_start:
	.quad  0

__fini_array_end:
	.quad  0
