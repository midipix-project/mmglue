############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under the Standard MIT License; see COPYING.MMGLUE.          ##
############################################################################

.section .midipix
	.ascii	"e35ed272"
	.ascii	"9e55"
	.ascii	"46c1"
	.ascii	"8251"
	.ascii	"022a59e6c480"
	.long	0
	.long	1
	.long	0
	.long	0
	.quad	__CTOR_LIST__
	.quad	__DTOR_LIST__

	# void *reserved[16];
	.quad	0x0
	.quad	0x1
	.quad	0x2
	.quad	0x3
	.quad	0x4
	.quad	0x5
	.quad	0x6
	.quad	0x7
	.quad	0x8
	.quad	0x9
	.quad	0xa
	.quad	0xb
	.quad	0xc
	.quad	0xd
	.quad	0xe
	.quad	0xf
