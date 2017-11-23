/****************************************/
/* statically linked applications only  */
/* see also: crtidata.c                 */
/****************************************/

int  __attribute__((__visibility__("hidden"))) __psx_init(int *,char ***,char ***,void *);
void __attribute__((__visibility__("hidden"))) __libc_entry_routine(void *,void *,int);

void __libc_loader_init(void * __main, int flags)
{
	__libc_entry_routine(__main,__psx_init,flags);
}

#include "crt1.c"
