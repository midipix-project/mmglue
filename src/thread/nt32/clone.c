/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

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
	uintptr_t       sbase;
	uintptr_t       slimit;
	uintptr_t       sbottom;
	void *          stack;

	struct pt_regs	regs;
	__sys_clone *	pfn_clone;
	pthread_t	pthread;

	regs.eip = (unsigned long)fn;
	regs.ecx = (unsigned long)arg;
	regs.edx = (unsigned long)pthread_self_addr;

	pfn_clone = (__sys_clone *)(__syscall_vtbl[SYS_clone]);

	sbase  = (uintptr_t)child_stack;
	sbase &= ~(uintptr_t)(0xf);
	stack  = (void *)sbase;

	if (flags == (CLONE_VM|CLONE_VFORK|SIGCHLD)) {
		regs.sbase   = 0;
		regs.slimit  = 0;
		regs.sbottom = 0;

		return (int)pfn_clone(
			flags,
			stack,
			0,0,&regs);
	}

	pthread = (pthread_t)pthread_self_addr;
	sbase   = (uintptr_t)pthread->stack;
	slimit  = sbase - pthread->stack_size;
	sbottom = slimit - pthread->guard_size;

	sbase  &= ~(uintptr_t)(0xf);
	slimit += 0xf;
	slimit |= 0xf;
	slimit ^= 0xf;

	regs.sbase   = sbase;
	regs.slimit  = slimit;
	regs.sbottom = sbottom;

	return (int)pfn_clone(
		flags,
		stack,
		ptid,
		ctid,
		&regs);
}
