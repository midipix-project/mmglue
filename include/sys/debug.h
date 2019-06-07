#ifndef _SYS_DEBUG_H
#define _SYS_DEBUG_H

#include <stdint.h>
#include <stddef.h>
#include <signal.h>
#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif

/* debug states */
enum __dbg_state {
	__DBG_STATE_IDLE,
	__DBG_STATE_REPLY_PENDING,

	__DBG_STATE_CREATE_THREAD,
	__DBG_STATE_CREATE_PROCESS,

	__DBG_STATE_EXIT_THREAD,
	__DBG_STATE_EXIT_PROCESS,

	__DBG_STATE_EXCEPTION,
	__DBG_STATE_BREAKPOINT,
	__DBG_STATE_SINGLE_STEP,

	__DBG_STATE_DLL_LOAD,
	__DBG_STATE_DLL_UNLOAD,
};

/* debug responses */
#define __DBG_RESPONSE_CONTINUE                 (0x00010002)
#define __DBG_RESPONSE_EXCEPTION_HANDLED        (0x00010001)
#define __DBG_RESPONSE_EXCEPTION_NOT_HANDLED    (0x80010001)
#define __DBG_RESPONSE_REPLY_LATER              (0x40010001)
#define __DBG_RESPONSE_TERMINATE_PROCESS        (0x40010004)
#define __DBG_RESPONSE_TERMINATE_THREAD         (0x40010003)

/* thread types */
#define __DBG_THREAD_TYPE_UNKNOWN       0x00
#define __DBG_THREAD_TYPE_PTHREAD       0x01
#define __DBG_THREAD_TYPE_DAEMON        0x02
#define __DBG_THREAD_TYPE_PTYREF        0x03
#define __DBG_THREAD_TYPE_POLLER        0x04
#define __DBG_THREAD_TYPE_WAITER        0x05
#define __DBG_THREAD_TYPE_TIMER         0x06
#define __DBG_THREAD_TYPE_BRIDGE        0x07
#define __DBG_THREAD_TYPE_PIPEIN        0x08
#define __DBG_THREAD_TYPE_PIPEOUT       0x09

#define __DBG_THREAD_TYPE_TTYANY        0x40
#define __DBG_THREAD_TYPE_TTYSRV        0x41
#define __DBG_THREAD_TYPE_TTYSVC        0x42
#define __DBG_THREAD_TYPE_TTYASYNC      0x43
#define __DBG_THREAD_TYPE_TTYCLIENT     0x44
#define __DBG_THREAD_TYPE_TTYDEBUG      0x45
#define __DBG_THREAD_TYPE_TTYCONN       0x46

/* exception source bits */
#define __DBG_EXCEPTION_SOURCE_UNKNOWN  0x00
#define __DBG_EXCEPTION_SOURCE_HARDWARE 0x01
#define __DBG_EXCEPTION_SOURCE_SOFTWARE 0x02
#define __DBG_EXCEPTION_SOURCE_KERNEL   0x04
#define __DBG_EXCEPTION_SOURCE_USER     0x08

/* exception record */
struct __erec {
	uint32_t        exception_code;
	uint32_t        exception_flags;
	struct __erec * exception_record;
	void *          exception_address;
	uint32_t        exception_params;
	uintptr_t       exception_info[0xf];
};

/* debug event alpha definition */
struct __dbg_event {
	int             evttype;
	int             evtzone;

	int32_t         estatus;
	int32_t         eresponse;

	uint64_t        evtkey;
	uint64_t        evtqpc;

	pid_t           cpid;
	pid_t           ctid;

	pid_t           syspid;
	pid_t           systid;

	mcontext_t *    thread_context;
	siginfo_t *     thread_siginfo;

	stack_t *       thread_cstack;
	stack_t *       thread_astack;
	sigset_t *      thread_sigmask;

	struct tstat *  thread_stat;
	struct __teb *  thread_teb;
	struct __tlca * thread_tlca;

	struct __erec * exception_record;
	uint32_t        exception_priority;
	uint32_t        exception_source;

	int             syscall_depth;
	int             syscall_number;
	intptr_t        syscall_result;
        intptr_t        syscall_params[6];

	uint32_t *      thread_subsystem_key;
	void *          thread_start_address;
	int32_t *       thread_exit_code;

	uint32_t *      process_subsystem_key;
	void *          process_image_handle;
	void *          process_image_base;
	int32_t *       process_exit_code;

	void *          module_image_handle;
	void *          module_image_base;

	uint32_t        dbg_info_offset;
	uint32_t        dbg_info_size;

	const char *    image_rpath;
	const char *    image_apath;
	const char *    image_npath;
	const char *    image_dpath;
};

/* pid (or syspid) --> debug file descriptor */
int __dbg_attach(pid_t);
int __dbg_detach(int);

/* process creation/suspension/termination --> debug file descriptor */
int __dbg_spawn(const char *, char **, char **);
int __dbg_fork(void);
int __dbg_suspend(int);
int __dbg_kill(int);

/* breakpoint via remote break-in, thread context manipulation, or lpc message */
int __dbg_rbreak(int);
int __dbg_tbreak(int);
int __dbg_lbreak(int);

/**
 * query one (or all) pending debug event(s) for the given debug
 *    file descriptor:
 * in the 'one' case, the return value indicates the total number
 *    of events that are pending for the given file descriptor;
 * in the 'all' case, the third argument specifies the number
 *    of elements in the user-provided buffer.
**/
int __dbg_event_query_one(int, struct __dbg_event *);
int __dbg_event_query_all(int, struct __dbg_event *, int);

/**
 * first acquire (remove from the queue) the next pending debug event;
 * later respond to the event, the default being __DBG_RESPONSE_CONTINUE.
**/
int __dbg_event_acquire(int, struct __dbg_event *);
int __dbg_event_respond(int, struct __dbg_event *);

/* debug file descriptor --> common (or system) pid */
int __dbg_query_cpid(int);
int __dbg_query_syspid(int);

/* code of last debug operation error encountered by this pthread */
int __dbg_common_error(void);
int __dbg_native_error(void);

#ifdef __cplusplus
}
#endif

#endif
