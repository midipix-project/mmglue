/****************************************/
/* statically linked applications only  */
/* see also: crtidata.c                 */
/****************************************/

static const unsigned char * __inherit = 0;
extern const unsigned char * __ctty    __attribute((weak,alias("__inherit")));

int  __attribute__((__visibility__("hidden"))) __psx_init(int *,char ***,char ***,void *);
void __attribute__((__visibility__("hidden"))) __libc_entry_routine(void *,void *,const unsigned short *,int);

void __libc_loader_init(void * __main, int flags)
{
	__libc_entry_routine(__main,__psx_init,__ctty,flags);
}

#include "crt1.c"
