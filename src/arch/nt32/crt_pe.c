/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include "pthread_impl.h"
#include <threads.h>

void * __pthread_getspecific_impl(pthread_key_t k)
{
	return (__pthread_self())->tsd[k];
}
