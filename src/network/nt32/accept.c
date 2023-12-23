/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <sys/socket.h>
#include "syscall.h"
#include "libc.h"

int accept(int fd, struct sockaddr *restrict addr, socklen_t *restrict len)
{
	return socketcall_cp(accept4, fd, addr, len, 0, 0, 0);
}
