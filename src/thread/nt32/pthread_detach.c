/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include "../thread/pthread_detach.c"

int __pthread_detach_impl(pthread_t t)
{
	return thrd_detach(t);
}
