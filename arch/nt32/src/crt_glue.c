#include <unistd.h>
#include <pthread.h>
#include "atomic.h"
#include "syscall.h"
#include "psxglue.h"
#include "pthread_impl.h"

extern const struct __ldso_vtbl * __ldso_vtbl;
extern const struct __psx_vtbl *  __psx_vtbl;

typedef int __app_main();
typedef int __pthread_surrogate_routine(struct pthread *);

static int __pthread_surrogate_init(struct pthread * self);

extern int __libc_start_main(
	void *	main,
	int	argc,
	char **	argv);

static void (*__global_ctors_fn)();
static void (*__global_dtors_fn)();

void _init()
{
	__global_ctors_fn();
}

void _fini()
{
	__global_dtors_fn();
}

struct __tls {
	void *		pad[16/sizeof(void *)];
	struct pthread	pt;
} __builtin_tls = {{0}};

void __init_tls (size_t * auxv)
{
	#define T __builtin_tls

	__set_thread_area(&T.pt);

	T.pt.self	= &T.pt;
	T.pt.locale	= &libc.global_locale;
	T.pt.tid	= __syscall(SYS_set_tid_address, &T.pt.tid);

	libc.can_do_threads = 1;
	libc.tls_size = sizeof(struct __tls);
};

void __libc_entry_routine(
	__app_main *		__main,
	__psx_init_routine *	__psx_init,
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
	if (__psx_init(&argc,&argv,&envp,&ctx))
		a_crash();

	/* ...and conform */
	else if (envp != argv + (argc + 1))
		a_crash();

	/* write once */
	__syscall_vtbl	= (unsigned long **)ctx.sys_vtbl;
	__ldso_vtbl	= ctx.ldso_vtbl;
	__psx_vtbl	= ctx.psx_vtbl;
	__teb_sys_idx	= ctx.teb_sys_idx;
	__teb_libc_idx	= ctx.teb_libc_idx;

	/* surrogate init/fini arrays */
	__global_ctors_fn = ctx.do_global_ctors_fn;
	__global_dtors_fn = ctx.do_global_dtors_fn;

	/* enter libc */
	__psx_vtbl->start_main(__main,argc,argv,__libc_start_main);

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
