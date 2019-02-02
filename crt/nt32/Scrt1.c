/****************************************/
/* statically linked applications only  */
/* see also: crtidata.c                 */
/****************************************/

#include "crtinit.h"

static const unsigned short * __inherit = 0;
extern const unsigned short * __ctty    __hidden __attribute((weak,alias("__inherit")));

int  __hidden __psx_init(int *,char ***,char ***,void *);
void __hidden __libc_entry_routine(void *,void *,const unsigned short *,int);

void __hidden __libc_loader_init(void * __main, int flags)
{
	__libc_entry_routine(__main,__psx_init,__ctty,flags);
}

#include "crt1.c"
