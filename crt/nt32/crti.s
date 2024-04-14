############################################################################
##  mmglue: midipix architecture- and target-specific bits for musl libc  ##
##  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   ##
##  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   ##
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
	.long	__CTOR_LIST__
	.long	__DTOR_LIST__

	# void *reserved[16];
	.long	0x0
	.long	0x1
	.long	0x2
	.long	0x3
	.long	0x4
	.long	0x5
	.long	0x6
	.long	0x7
	.long	0x8
	.long	0x9
	.long	0xa
	.long	0xb
	.long	0xc
	.long	0xd
	.long	0xe
	.long	0xf
