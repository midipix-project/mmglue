/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include "pthread_impl.h"
#include <threads.h>
#include "libc.h"

pthread_t pthread_self()
{
	return __pthread_self();
}

weak_alias(pthread_self, thrd_current);
