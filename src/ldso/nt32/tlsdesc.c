/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include <stddef.h>

ptrdiff_t __tlsdesc_static(void)
{
	return 0;
}

ptrdiff_t  __tlsdesc_dynamic(void) __attribute__((alias("__tlsdesc_static")));
