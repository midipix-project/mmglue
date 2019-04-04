#define  _GNU_SOURCE

#include <syscall.h>
#include <sched.h>

/* take advantage of winnt's x64 vararg abi */
#define  __clone ____clone
#include "pthread_impl.h"
#undef   __clone

struct pt_regs {
	unsigned long	r15;
	unsigned long	r14;
	unsigned long	r13;
	unsigned long	r12;
	unsigned long	rbp;
	unsigned long	rbx;
	unsigned long	r11;
	unsigned long	r10;
	unsigned long	r9;
	unsigned long	r8;
	unsigned long	rax;
	unsigned long	rcx;
	unsigned long	rdx;
	unsigned long	rsi;
	unsigned long	rdi;
	unsigned long	orig_rax;
	unsigned long	rip;
	unsigned long	cs;
	unsigned long	eflags;
	unsigned long	rsp;
	unsigned long	ss;
	uintptr_t	sbase;
	uintptr_t	slimit;
	uintptr_t	sbottom;
};

typedef long __sys_clone(
	unsigned long	flags,
	void *		child_stack,
	void *		ptid,
	void *		ctid,
	struct pt_regs *regs);

extern unsigned long ** __syscall_vtbl;

hidden int __clone(
	int             (*fn)(void *),
	void *		child_stack,
	int		flags,
	void *		arg,
	int *		ptid,
	void *		pthread_self_addr,
	int *		ctid)
{
	struct pt_regs	regs;
	__sys_clone *	pfn_clone;
	pthread_t	pthread;

	regs.rip = (unsigned long)fn;
	regs.rcx = (unsigned long)arg;
	regs.rdx = (unsigned long)pthread_self_addr;

	pfn_clone = (__sys_clone *)(__syscall_vtbl[SYS_clone]);

	if (flags == CLONE_VM|CLONE_VFORK|SIGCHLD) {
		regs.sbase   = 0;
		regs.slimit  = 0;
		regs.sbottom = 0;

		return (int)pfn_clone(
			flags,
			child_stack,
			0,0,&regs);
	}

	pthread      = (pthread_t)pthread_self_addr;
	regs.sbase   = (unsigned long)pthread->stack;
	regs.slimit  = regs.sbase  - pthread->stack_size;
	regs.sbottom = regs.slimit - pthread->guard_size;

	return (int)pfn_clone(
		flags,
		child_stack,
		ptid,
		ctid,
		&regs);
}
