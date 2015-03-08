#define _BSD_SOURCE

#include <dlfcn.h>
#include "pthread_impl.h"

int __dladdr(const void * addr, Dl_info * info)
{
	return 0;
}

int __dlinfo(void * dso, int req, void * res)
{
	return 0;
}

void *__dlsym(void * restrict p, const char * restrict s, void * restrict ra)
{
	return 0;
}

void * dlopen(const char * file, int mode)
{
	return 0;
}

int dlclose(void *p)
{
        return 0;
}

char * dlerror(void)
{
	return 0;
}

void __reset_tls(void)
{
}

void *__copy_tls(unsigned char * mem)
{
	/**
	 * this is always the simple case, since:
	 * emutls is based on PE named sections; and
	 * tls allocation and initialization are handled by clone(2)
	**/

        pthread_t td;
        void **	  dtv;

	dtv = (void **)mem;
	dtv[0] = 0;

	td = (void *)(dtv + 1);
	td->dtv = dtv;

	return td;
}
