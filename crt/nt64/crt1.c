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
	__libc_loader_init(
		main,
		__crtopt_posix
			| __crtopt_dinga
			| __crtopt_ldso
			| __crtopt_vrfs);
}
