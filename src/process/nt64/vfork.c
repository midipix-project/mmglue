/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#define _GNU_SOURCE
#include <unistd.h>
#include "syscall.h"
#include "libc.h"

pid_t __vfork(void)
{
	return syscall(SYS_vfork);
}

weak_alias(__vfork, vfork);
