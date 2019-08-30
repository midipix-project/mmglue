#include <sys/cmd.h>
#include "syscall.h"

int __cmd_args_to_argv(
	const char * args,
	char * argbuf, size_t buflen,
	char ** argv, size_t nptrs)
{
	return __syscall(SYS_cmd_args_to_argv,args,argbuf,buflen,argv,nptrs);
}
