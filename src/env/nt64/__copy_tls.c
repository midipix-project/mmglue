/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#define _BSD_SOURCE

#include <unistd.h>
#include "psxglue.h"
#include "pthread_impl.h"

extern const struct __ldso_vtbl * __ldso_vtbl;
extern const struct __psx_vtbl *  __psx_vtbl;

void *__copy_tls(unsigned char * mem)
{
	/**
	 * this is always the simple case, since:
	 * emutls is based on PE named sections; and
	 * tls allocation and initialization are handled by clone(2)
	**/

        pthread_t td;
	uintptr_t addr;

	addr = (uintptr_t)mem;
	addr += 0xf;
	addr |= 0xf;
	addr ^= 0xf;

	td = (struct __pthread *)addr;
	td->dtv = 0;

	return td;
}
