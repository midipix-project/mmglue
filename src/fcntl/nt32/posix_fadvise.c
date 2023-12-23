/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include "fcntl.h"
#include "syscall_arch.h"

int posix_fadvise (int fd, off_t base, off_t len, int advice)
{
	/**
	 *  __syscall is needed here due to the odd semantics
	 *  of posix_fadvise(), which for us means calling
	 *  __sys_fadvise() directly.
	**/

	return 0; /* __sys_fadvise (fd, base, len, advice); */
}

