#ifndef _PSXGLUE_H_
#define _PSXGLUE_H_

#define __PSXOPT_NATIVE		0x0
#define __PSXOPT_POSIX		0x1
#define __PSXOPT_DINGA		0x2
#define __PSXOPT_LDSO		0x4
#define __PSXOPT_VRFS		0x8

struct __seh_vtbl;

struct __ldso_vtbl {
	int	(*dladdr)	(const void * addr, void * info);
	int	(*dlinfo)	(void * dso, int req, void * res);
	void *	(*dlsym)	(void * p, const char * s, void * ra);
	void *	(*dlopen)	(const char * file, int mode, const char ** pathv, int * status);
	int	(*dlclose)	(void *p);
	char *	(*dlerror)	(void);
	void	(*tlsreset)	(void);
};

struct __psx_vtbl {
	void	(*do_global_ctors_fn)	();
	void	(*do_global_dtors_fn)	();
	int	(*fs_rpath)		(int, const char *, int, char *, size_t);
	int	(*fs_apath)		(int, const char *, int, char *, size_t);
	int	(*fs_npath)		(int, const char *, int, char *, size_t);
	int	(*fs_dpath)		(int, const char *, int, char *, size_t);
	int	(*mm_start_main)	(int, char **, int (*)());
	void	(*mm_convert_thread)	(void);
	void	(*mm_unmapself)		(void *, size_t);
	ssize_t	(*mm_log_output)	(void *, ssize_t);
};

struct __tlca_abi {
	void *	pthread_self;
	int *	pthread_set_child_tid;
	int *	pthread_clear_child_tid;
	char *	pthread_tls;
	char **	pthread_dtls;
};

struct __psx_context {
	int				size;
	int				options;
	void *				ldsoaddr;
	const unsigned short *		ctty;
	void **				sys_vtbl;
	const struct __seh_vtbl *	seh_vtbl;
	const struct __ldso_vtbl *	ldso_vtbl;
	const struct __psx_vtbl *	psx_vtbl;
	unsigned int			teb_sys_idx;
	unsigned int			teb_libc_idx;
	void *				pthread_surrogate_fn;
	void *				pthread_create_fn;
	int				(*usrmain)();
};

typedef int __psx_init_routine(
	int *			argc,
	char ***		argv,
	char ***		envp,
	struct __psx_context *	ctx);

#endif
