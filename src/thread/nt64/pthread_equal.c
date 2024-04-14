/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include "../thread/pthread_equal.c"

int __pthread_equal_impl(pthread_t a, pthread_t b)
{
	return thrd_equal(a,b);
}
