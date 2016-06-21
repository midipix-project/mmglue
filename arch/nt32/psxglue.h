#ifndef _PSXGLUE_H_
#define _PSXGLUE_H_

#define __PSXOPT_NATIVE		0x0
#define __PSXOPT_POSIX		0x1
#define __PSXOPT_TTYDBG		0x2
#define __PSXOPT_LDSO		0x4

typedef int	__ldso_dladdr(const void * addr, void * info);
typedef int	__ldso_dlinfo(void * dso, int req, void * res);
typedef void *	__ldso_dlsym(void * p, const char * s, void * ra);
typedef void *	__ldso_dlopen(const char * file, int mode);
typedef int	__ldso_dlclose(void *p);
typedef char *	__ldso_dlerror(void);
typedef void	__ldso_reset_tls(void);

typedef void	__psx_convert_thread(void);
typedef void	__psx_unmapself(void *, void *);
typedef void *	__psx_get_osfhandle(int fd);
typedef long	__psx_log_output(char *, signed int);

struct __ldso_vtbl {
	__ldso_dladdr *		dladdr;
	__ldso_dlinfo *		dlinfo;
	__ldso_dlsym *		dlsym;
	__ldso_dlopen *		dlopen;
	__ldso_dlclose *	dlclose;
	__ldso_dlerror *	dlerror;
	__ldso_reset_tls *	reset_tls;
};

struct __psx_vtbl {
	__psx_convert_thread *	convert_thread;
	__psx_unmapself *	unmapself;
	__psx_get_osfhandle *	get_osfhandle;
	__psx_log_output *	log_output;
};

struct __psx_context {
	int			size;
	int			options;
	void ***		sys_vtbl;
	struct __ldso_vtbl *	ldso_vtbl;
	struct __psx_vtbl *	psx_vtbl;
	unsigned int		teb_sys_idx;
	unsigned int		teb_libc_idx;
	void *			pthread_surrogate_fn;
	void *			pthread_create_fn;
	void *			do_global_ctors_fn;
	void *			do_global_dtors_fn;
};

struct __tlca {
	void *	pthread_self;
	int *	pthread_set_child_tid;
	int *	pthread_clear_child_tid;
	char *	pthread_tls;
	char **	pthread_dtls;
};

typedef int __psx_init_routine(
	int *			argc,
	char ***		argv,
	char ***		envp,
	struct __psx_context *	ctx);

#endif
