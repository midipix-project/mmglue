/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#ifdef LIBC_NO_COMPLEX

.globl ___udivdi3
.globl ___umoddi3
.globl ___divdi3
.globl ___moddi3

___udivdi3:
	ret

___umoddi3:
	ret

___divdi3:
	ret

___moddi3:
	ret

#endif
