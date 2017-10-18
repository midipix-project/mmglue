/**
 * options: posix session, fallback terminal emulator
 * x86_64-nt64-midipix-gcc --target-help | grep -A2 posix
**/

static const int __disabled = 0;
extern const int __crtopt_posix  __attribute((weak,alias("__disabled")));
extern const int __crtopt_dinga __attribute((weak,alias("__disabled")));
extern const int __crtopt_ldso  __attribute((weak,alias("__disabled")));
extern const int __crtopt_vrfs  __attribute((weak,alias("__disabled")));

int  main();
void __libc_loader_init(void * __main, int flags);

void _start(void)
{
	__libc_loader_init(
		main,
		__crtopt_posix
			| __crtopt_dinga
			| __crtopt_ldso
			| __crtopt_vrfs);
}
