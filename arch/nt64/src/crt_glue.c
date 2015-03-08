#include <unistd.h>
#include <pthread.h>
#include "atomic.h"
#include "syscall.h"
#include "psxglue.h"
#include "pthread_impl.h"

extern struct __ldso_vtbl *	__ldso_vtbl;
extern struct __psx_vtbl *	__psx_vtbl;

typedef int __app_main();
typedef int __pthread_surrogate_routine(struct pthread *);

extern int _init(void);
static int __pthread_surrogate_init(struct pthread * self);

extern int __libc_start_main(
	void *	main,
	int	argc,
	char **	argv);

void __libc_entry_routine(
	__app_main *		__main,
	__psx_init_routine *	__psx_init_routine,
	int			options)
{
	int			argc;
	char **			argv;
	char **			envp;
	struct __psx_context	ctx;

	/* ctx init */
	ctx.size		= sizeof(ctx);
	ctx.options		= options;
	ctx.pthread_create_fn	= pthread_create;
	ctx.pthread_surrogate_fn= __pthread_surrogate_init;

	/* __psx_init must succeed... */
	if (__psx_init_routine(&argc,&argv,&envp,&ctx))
		a_crash();

	/* ...and conform */
	else if (envp != argv + (argc + 1))
		a_crash();

	/* dso init routines */
	_init();

	/* write once */
	__syscall_vtbl	= (unsigned long **)ctx.sys_vtbl;
	__ldso_vtbl	= ctx.ldso_vtbl;
	__psx_vtbl	= ctx.psx_vtbl;
	__teb_sys_idx	= ctx.teb_sys_idx;
	__teb_libc_idx	= ctx.teb_libc_idx;

	/* enter libc */
	__libc_start_main(__main,argc,argv);

	/* guard */
	a_crash();
}

static int __pthread_surrogate_init(struct pthread * self)
{
	/**
	 * invoked by psxscl upon creation of a surrogate libc
	 * thread, which in turn may only call pthread_create();
	 *
	 * the purpose of this mecahnism is to support a scenario
	 * where a third-party library creates a non-posix thread
	 * which then calls, be it directly or via a callback
	 * function, a libc api that depends on a valid
	 * pthread_self.
	 *
	 * self: a pointer to an already zero'ed memory page
	 *
	 * struct pthread relevant members:
	 * --------------------------------
	 * cancel (already zero)
	 * canary (already zero)
	 *
	 * pthread_create() reference:
	 * 1a47ed15eebf96d0c8d5de4aea54108bc8cc3f53
	**/

	return 0;
}
