/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include "crtinit.h"

static const int __disabled = 0;
extern const int __hidden __crtopt_posix  __attribute((weak,alias("__disabled")));
extern const int __hidden __crtopt_dinga  __attribute((weak,alias("__disabled")));
extern const int __hidden __crtopt_ldso   __attribute((weak,alias("__disabled")));
extern const int __hidden __crtopt_vrfs   __attribute((weak,alias("__disabled")));

int  __hidden main();
void __hidden __libc_loader_init(void * __main, int flags);

void __hidden _start(void)
{
	const unsigned short fmode = 0x37f;

	__asm__ __volatile__ (
		"fldcw %0"
		: : "m" (*&fmode));

	__libc_loader_init(
		main,
		__crtopt_posix
			| __crtopt_dinga
			| __crtopt_ldso
			| __crtopt_vrfs);
}
