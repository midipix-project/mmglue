#define  _GNU_SOURCE

#include <syscall.h>
#include <sched.h>

/* take advantage of i686 vararg abi */
#define  __clone ____clone
#include "pthread_impl.h"
#undef   __clone

struct pt_regs {
	unsigned long	ebx;
	unsigned long	ecx;
	unsigned long	edx;
	unsigned long	esi;
	unsigned long	edi;
	unsigned long	ebp;
	unsigned long	eax;
	unsigned long	xds;
	unsigned long	xes;
	unsigned long	xfs;
	unsigned long	xgs;
	unsigned long	orig_eax;
	unsigned long	eip;
	unsigned long	xcs;
	unsigned long	eflags;
	unsigned long	esp;
	unsigned long	xss;
	unsigned long	sbase;
	unsigned long	slimit;
	unsigned long	sbottom;
};

typedef long __sys_clone(
	unsigned long	flags,
	void *		child_stack,
	void *		ptid,
	void *		ctid,
	struct pt_regs *regs);

extern unsigned long ** __syscall_vtbl;

int __clone(
	__entry_point *	fn,
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

	regs.eip = (unsigned long)fn;
	regs.ecx = (unsigned long)arg;
	regs.edx = (unsigned long)pthread_self_addr;

	pfn_clone = (__sys_clone *)(__syscall_vtbl[SYS_clone]);

	if (flags == (CLONE_VM|CLONE_VFORK|SIGCHLD)) {
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
