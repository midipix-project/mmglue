#define _GNU_SOURCE
#include <unistd.h>
#include "syscall.h"
#include "libc.h"

pid_t __vfork(void)
{
	return syscall(SYS_vfork);
}

weak_alias(__vfork, vfork);
