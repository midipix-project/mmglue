#include <syscall.h>

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
};

typedef long __sys_clone(
	unsigned long	flags,
	void *		child_stack,
	void *		ptid,
	void *		ctid,
	struct pt_regs *regs);

typedef int __entry_point(void *);

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

	regs.rip = (unsigned long)fn;
	regs.rcx = (unsigned long)arg;
	regs.rdx = (unsigned long)pthread_self_addr;

	pfn_clone = (__sys_clone *)(__syscall_vtbl[SYS_clone]);

	return (int)pfn_clone(
		flags,
		child_stack,
		ptid,
		ctid,
		&regs);
}
