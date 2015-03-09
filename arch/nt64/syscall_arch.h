extern unsigned long ** __syscall_vtbl;

typedef long __syscall0_fn(void);
typedef long __syscall1_fn(long a1);
typedef long __syscall2_fn(long a1, long a2);
typedef long __syscall3_fn(long a1, long a2, long a3);
typedef long __syscall4_fn(long a1, long a2, long a3, long a4);
typedef long __syscall5_fn(long a1, long a2, long a3, long a4, long a5);
typedef long __syscall6_fn(long a1, long a2, long a3, long a4, long a5, long a6);

#define sysfn_from_fn(x) \
	x * sysfn = (x *)__syscall_vtbl[n]

static __inline long __syscall0(long n)
{
	sysfn_from_fn(__syscall0_fn);
	return sysfn();
}

static __inline long __syscall1(long n, long a1)
{
	sysfn_from_fn(__syscall1_fn);
	return sysfn(a1);
}

static __inline long __syscall2(long n, long a1, long a2)
{
	sysfn_from_fn(__syscall2_fn);
	return sysfn(a1, a2);
}

static __inline long __syscall3(long n, long a1, long a2, long a3)
{
	sysfn_from_fn(__syscall3_fn);
	return sysfn(a1, a2, a3);
}

static __inline long __syscall4(long n, long a1, long a2, long a3, long a4)
{
	sysfn_from_fn(__syscall4_fn);
	return sysfn(a1, a2, a3, a4);
}

static __inline long __syscall5(long n, long a1, long a2, long a3, long a4, long a5)
{
	sysfn_from_fn(__syscall5_fn);
	return sysfn(a1, a2, a3, a4, a5);
}

static __inline long __syscall6(long n, long a1, long a2, long a3, long a4, long a5, long a6)
{
	sysfn_from_fn(__syscall6_fn);
	return sysfn(a1, a2, a3, a4, a5, a6);
}


#define __SYSCALL_LL_E(x) (x)
#define __SYSCALL_LL_O(x) (x)
