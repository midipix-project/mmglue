/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include <stdint.h>
#include <stddef.h>
#include <signal.h>
#include <unistd.h>
#include <sys/debug.h>
#include "syscall.h"

int __dbg_attach(pid_t pid)
{
	return syscall(SYS_dbg_attach,pid);
}

int __dbg_detach(int pfd)
{
	return syscall(SYS_dbg_detach,pfd);
}

int __dbg_spawn(const char * path,
		char ** argv, char ** envp,
		const struct __strace * strace)
{
	return syscall(SYS_dbg_spawn,path,argv,envp,strace);
}

int __dbg_fork()
{
	return syscall(SYS_dbg_fork);
}

int __dbg_kill(int pfd)
{
	return syscall(SYS_dbg_kill,pfd);
}

int __dbg_rbreak(int pfd)
{
	return syscall(SYS_dbg_rbreak,pfd);
}

int __dbg_tbreak(int pfd)
{
	return syscall(SYS_dbg_tbreak,pfd);
}

int __dbg_lbreak(int pfd)
{
	return syscall(SYS_dbg_lbreak,pfd);
}

ssize_t __dbg_vm_read(int pfd, void * buf, size_t len, uintptr_t addr)
{
	return syscall(SYS_dbg_vm_read,pfd,buf,len,addr);
}

ssize_t __dbg_vm_write(int pfd, const void * buf, size_t len, uintptr_t addr)
{
	return syscall(SYS_dbg_vm_write,pfd,buf,len,addr);
}

int __dbg_regs_fetch(int pfd, pid_t tid, mcontext_t * regctx)
{
	return syscall(SYS_dbg_regs_fetch,pfd,tid,regctx);
}

int __dbg_regs_store(int pfd, pid_t tid, const mcontext_t * regctx)
{
	return syscall(SYS_dbg_regs_store,pfd,tid,regctx);
}

ssize_t __dbg_info_get(int pfd, pid_t tid, int type, void * buf, size_t len)
{
	return syscall(SYS_dbg_info_get,pfd,tid,type,buf,len);
}

ssize_t __dbg_info_set(int pfd, pid_t tid, int type, const void * buf, size_t len)
{
	return syscall(SYS_dbg_info_set,pfd,tid,type,buf,len);
}

int __dbg_suspend_thread(int pfd, pid_t tid)
{
	return syscall(SYS_dbg_suspend_thread,pfd,tid);
}

int __dbg_resume_thread(int pfd, pid_t tid)
{
	return syscall(SYS_dbg_resume_thread,pfd,tid);
}

int __dbg_event_query_one(int pfd, struct __dbg_event * evt)
{
	return syscall(SYS_dbg_event_query_one,pfd,evt);
}

int __dbg_event_query_all(int pfd, struct __dbg_event evt[], int nelem)
{
	return syscall(SYS_dbg_event_query_all,pfd,evt,nelem);
}

int __dbg_event_acquire(int pfd, struct __dbg_event * evt)
{
	return syscall(SYS_dbg_event_acquire,pfd,evt);
}

int __dbg_event_respond(int pfd, struct __dbg_event * evt)
{
	return syscall(SYS_dbg_event_respond,pfd,evt);
}

int __dbg_query_cpid(int pfd)
{
	return syscall(SYS_dbg_query_cpid,pfd);
}

int __dbg_query_syspid(int pfd)
{
	return syscall(SYS_dbg_query_syspid,pfd);
}

int __dbg_common_error(void)
{
	return syscall(SYS_dbg_common_error);
}

int __dbg_native_error(void)
{
	return syscall(SYS_dbg_native_error);
}
