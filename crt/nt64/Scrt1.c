#include "psxglue.h"

__psx_init_routine __psx_init;

__psx_init_routine * __psx_init_fn(void)
{
	return __psx_init;
}

#define  LIBC_STATIC
#include "crt1.c"
