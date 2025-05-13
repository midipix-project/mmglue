/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#define _BSD_SOURCE

#include <unistd.h>
#include <stdint.h>
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
				} else {
					ch++;
				}
			}

			next = *ch ? ch : (*++ch ? ch : 0);
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

void * __dldopen(int fd, int mode)
{
	int		status;
	void *		base;
	int		cs;

	/* prolog */
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &cs);
	pthread_rwlock_wrlock(&__ldso_lock);
	__inhibit_ptc();

	/* dldopen */
	base = __ldso_vtbl->dldopen(fd,mode,&status);

	/* epilog */
	__release_ptc();
	pthread_rwlock_unlock(&__ldso_lock);

	if (base)
		__psx_vtbl->do_global_ctors_fn();

	pthread_setcancelstate(cs, 0);

	return base;
}

void * __dlsopen(const char * file, int mode)
{
	int		status;
	void *		base;
	int		cs;

	/* prolog */
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &cs);
	pthread_rwlock_wrlock(&__ldso_lock);
	__inhibit_ptc();

	/* dlsopen */
	base = __ldso_vtbl->dlsopen(file,mode,&status);

	/* epilog */
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
	return (__ldso_vtbl->dlinfo(dso,req,res)) ? -1 : 0;
}

void *__dlsym(void * restrict p, const char * restrict s, void * restrict a)
{
	return __ldso_vtbl->dlsym(p,s,a);
}

int dlclose(void *p)
{
        return __ldso_vtbl->dlclose(p);
}

char * dlerror(void)
{
	return __ldso_vtbl->dlerror();
}

weak_alias(__dladdr,dladdr);
weak_alias(__dlinfo,dlinfo);
