#include <stddef.h>

#define	TP_ADJ(p)	(p)
#define	CANCEL_REG_IP	0x1F
#define MC_PC           uc_rip

extern uintptr_t __teb_sys_idx;
extern uintptr_t __teb_libc_idx;

struct __os_tib {
	void *	exception_list;
	void *	stack_base;
	void *	stack_limit;
};

static __inline__ void * __os_get_teb_address(void)
{
	void * ptrRet;
	__asm__ __volatile__ (
		"mov %%gs:0x30, %0\n\t"
		: "=r" (ptrRet) : :
		);
	return ptrRet;
}


static inline void __pthread_convert(void)
{
	/* (third-party thread support) */
	__asm__ __volatile__ (
		"push %rax\n\t"
		"movq __psx_vtbl,%rax\n\t"
		"sub $0x28,%rsp\n\t"
		"call *(%rax)\n\t"
		"add $0x28,%rsp\n\t"
		"pop  %rax\n\t"
		);
}


static inline struct pthread ** __psx_tlca(void)
{
	struct pthread **	ptlca;
	struct __os_tib *	tib;
	void **			slots;
	void ***		xslots;
	uintptr_t		sys_idx;

	tib = __os_get_teb_address();
	sys_idx = __teb_sys_idx;

	if (sys_idx < 64) {
		slots = (void **)((uintptr_t)tib + 0x1480);
		ptlca = (struct pthread **)(slots[sys_idx]);
	} else {
		xslots = (void ***)((uintptr_t)tib + 0x1780);
		slots  = *xslots;
		ptlca = (struct pthread **)(slots[sys_idx - 64]);
	}

	return ptlca;
}


#ifdef __MUSL_PRE___GET_TP
static inline struct pthread * __pthread_self(void)
#else
static inline struct pthread * __get_tp(void)
#endif
{
	struct pthread ** ptlca;

	ptlca = __psx_tlca();
	if (ptlca) return *ptlca;

	/* (third-party thread) */
	__pthread_convert();
	ptlca = __psx_tlca();
	return *ptlca;
}

