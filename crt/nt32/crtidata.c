/****************************************/
/* dynamically linked applications only */
/* see also: Scrt1.c                    */
/****************************************/

#include "psxglue.h"

#define __external_routine __attribute__((dllimport))

__external_routine
__psx_init_routine __psx_init;

__psx_init_routine * __psx_init_fn(void)
{
	return __psx_init;
}
