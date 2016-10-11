#define _BSD_SOURCE

#include <stdlib.h>
#include <dlfcn.h>
#include "psxglue.h"
#include "pthread_impl.h"

extern struct __ldso_vtbl * __ldso_vtbl;

int __dladdr(const void * addr, Dl_info * info)
{
	return __ldso_vtbl->dladdr(addr,info);
}

int __dlinfo(void * dso, int req, void * res)
{
	return __ldso_vtbl->dlinfo(dso,req,res);
}

void *__dlsym(void * restrict p, const char * restrict s, void * restrict ra)
{
	return __ldso_vtbl->dlsym(p,s,ra);
}

void * dlopen(const char * file, int mode)
{
	return __ldso_vtbl->dlopen(
		file,mode,
		getenv("LD_LIBRARY_PATH"),
		0);
}

int dlclose(void *p)
{
        return __ldso_vtbl->dlclose(p);
}

char * dlerror(void)
{
	return __ldso_vtbl->dlerror();
}

void __reset_tls(void)
{
	__ldso_vtbl->reset_tls();
}

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
	addr >>= 4;
	addr <<= 4;
	addr +=  16;

	td = (struct __pthread *)addr;
	td->dtv = 0;

	return td;
}
