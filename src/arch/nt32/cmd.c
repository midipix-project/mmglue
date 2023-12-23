/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <sys/cmd.h>
#include "syscall.h"

int __cmd_args_to_argv(
	const char * args,
	char * argbuf, size_t buflen,
	char ** argv, size_t nptrs)
{
	return syscall(SYS_cmd_args_to_argv,args,argbuf,buflen,argv,nptrs);
}
