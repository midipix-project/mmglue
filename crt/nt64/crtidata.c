/****************************************/
/* dynamically linked applications only */
/* see also: Scrt1.c                    */
/****************************************/

#define __external_routine __attribute__((dllimport))

__external_routine int  __psx_init(int *,char ***,char ***,void *);
__external_routine void __libc_entry_routine(void *,void *,int);

void __libc_loader_init(void * __main, int flags)
{
	__libc_entry_routine(__main,__psx_init,flags);
}
