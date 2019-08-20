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

int __dbg_spawn(const char * path, char ** argv, char ** envp)
{
	return syscall(SYS_dbg_spawn,path,argv,envp);
}

int __dbg_fork()
{
	return syscall(SYS_dbg_fork);
}

int __dbg_suspend(int pfd)
{
	return syscall(SYS_dbg_suspend,pfd);
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
