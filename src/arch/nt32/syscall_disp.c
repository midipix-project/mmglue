#include <unistd.h>
#include <stdint.h>
#include <stddef.h>
#include "syscall.h"
#include "psxglue.h"

extern struct __psx_vtbl * __psx_vtbl;

void __unmapself(void * base, size_t size)
{
	__psx_vtbl->unmapself(base,size);
}

uintptr_t __syscall_disp(long n,
		uintptr_t a1,
		uintptr_t a2,
		uintptr_t a3,
		uintptr_t a4,
		uintptr_t a5,
		uintptr_t a6)
{
	return __syscall(n,a1,a2,a3,a4,a5,a6);
}
