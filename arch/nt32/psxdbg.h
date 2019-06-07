#ifndef _PSXDBG_H_
#define _PSXDBG_H_

struct __dbg_event;

struct __dbg_vtbl {
	int (*dbg_attach)(pid_t);
	int (*dbg_detach)(int);

	int (*dbg_spawn)(const char *, char **, char **);
	int (*dbg_fork)(void);
	int (*dbg_suspend)(int);
	int (*dbg_kill)(int);

	int (*dbg_rbreak)(int);
	int (*dbg_tbreak)(int);
	int (*dbg_lbreak)(int);

	int (*dbg_event_query_one)(int, struct __dbg_event *);
	int (*dbg_event_query_all)(int, struct __dbg_event *, int);

	int (*dbg_event_acquire)(int, struct __dbg_event *);
	int (*dbg_event_respond)(int, struct __dbg_event *);

	int (*dbg_query_cpid)(int);
	int (*dbg_query_syspid)(int);

	int (*dbg_common_error)(void);
	int (*dbg_native_error)(void);
};

#endif
