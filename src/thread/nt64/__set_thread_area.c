/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <errno.h>
#include "pthread_impl.h"

int __set_thread_area(void * p)
{
	struct pthread ** ptlca;

	ptlca = __psx_tlca();
	if (!ptlca) return -ESRCH;

	*ptlca = p;
	return 0;
}
