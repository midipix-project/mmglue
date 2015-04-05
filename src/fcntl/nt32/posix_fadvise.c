#include "fcntl.h"
#include "syscall_arch.h"

int posix_fadvise (int fd, off_t base, off_t len, int advice)
{
	/**
	 *  __syscall is needed here due to the odd semantics
	 *  of posix_fadvise(), which for us means calling
	 *  __sys_fadvise() directly.
	**/

	return 0; /* __sys_fadvise (fd, base, len, advice); */
}

