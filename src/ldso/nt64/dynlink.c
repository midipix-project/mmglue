#define _BSD_SOURCE

#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include "psxglue.h"
#include "pthread_impl.h"

extern const struct __ldso_vtbl * __ldso_vtbl;
extern const struct __psx_vtbl *  __psx_vtbl;

static pthread_rwlock_t __ldso_lock;

void * dlopen(const char * file, int mode)
{
	int		status;
	void *		base;
	int		cs;
	char *		ch;
	char *		next;
	char *		epath;
	char *		lpath;
	const char **	lpathv;
	const char **	epathv;
	char		lpathbuf[2048];
	const char *	lpathvbuf[64];
	int		i;

	/* prolog */
	if (!file)
		return __ldso_vtbl->dlopen(0,mode,0,&status);

	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &cs);
	pthread_rwlock_wrlock(&__ldso_lock);
	__inhibit_ptc();

	/* loader path environment variable to loader path vector */
	if ((epath = getenv("LD_LIBRARY_PATH"))) {
		lpath = (strncpy(lpathbuf,epath,2048) < &lpathbuf[2048])
			? lpathbuf
			: strdup(epath);

		if ((i = !!lpath))
			for (ch=lpath; *ch; ch++)
				if (*ch == ':')
					i++;

		lpathv = (++i < 64)
			? lpathvbuf
			: calloc(++i,sizeof(char *));
	} else {
		lpath    = lpathbuf;
		lpathv   = lpathvbuf;
		lpath[0] = 0;
	}

	if (lpath && lpathv) {
		ch     = lpath;
		next   = *ch ? ch : 0;
		epathv = lpathv;

		for (; next; ) {
			*epathv++ = (*next == ':')
				? "."
				: next;

			ch = &next[1];

			for (; *ch; ) {
				if (*ch == ':') {
					*ch = 0;
					ch  = 0;
				} else {
					ch++;
				}
			}

			next = *ch ? ch : 0;
		}

		*epathv = 0;
	}

	/* dlopen */
	base = (lpath && lpathv)
		? __ldso_vtbl->dlopen(file,mode,lpathv,&status)
		: 0;

	/* epilog */
	if (lpath && (lpath != lpathbuf))
		free(lpath);

	if (lpathv && (lpathv != lpathvbuf))
		free(lpathv);

	__release_ptc();
	pthread_rwlock_unlock(&__ldso_lock);

	if (base)
		__psx_vtbl->do_global_ctors_fn();

	pthread_setcancelstate(cs, 0);

	return base;
}

int __dladdr(const void * addr, Dl_info * info)
{
	return __ldso_vtbl->dladdr(addr,info);
}

int __dlinfo(void * dso, int req, void * res)
{
	return __ldso_vtbl->dlinfo(dso,req,res);
}

void *__dlsym(void * restrict p, const char * restrict s)
{
	return __ldso_vtbl->dlsym(p,s,0);
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
