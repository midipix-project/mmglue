/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include "syscall.h"

extern const struct __psx_vtbl *  __psx_vtbl;

char * realpath(const char * restrict filename, char * restrict resolved)
{
	int  ecode;
	char buf[PATH_MAX];

	ecode = filename
		? __syscall(SYS_fs_rpath,
			AT_FDCWD,filename,
			O_NONBLOCK|O_CLOEXEC,
			buf,sizeof(buf))
		: -EINVAL;

	if (ecode < 0) {
		errno = -ecode;
		return 0;
	}

	return resolved
		? strcpy(resolved,buf)
		: strdup(buf);
}
