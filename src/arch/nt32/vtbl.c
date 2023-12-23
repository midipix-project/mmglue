/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <unistd.h>
#include <stdint.h>
#include "psxglue.h"
#include "errno.h"

const struct __ldso_vtbl *  __ldso_vtbl     = 0;
const struct __psx_vtbl *   __psx_vtbl      = 0;
const struct __seh_vtbl *   __eh_vtbl       = 0;

unsigned long **            __syscall_vtbl  = 0;
unsigned long               __teb_sys_idx   = 0;
unsigned long               __teb_libc_idx  = 0;

long __syscall_alert(long n)
{
	char __lmsg[] = "DING ALARM! UNIMPLEMENTED SYSCALL 000\n";

	__lmsg[36] = '0' + n % 10; n /= 10;
	__lmsg[35] = '0' + n % 10; n /= 10;
	__lmsg[34] = '0' + n % 10;

	__psx_vtbl->mm_log_output(
		__lmsg,
		sizeof(__lmsg));

	return -ENOSYS;
}
