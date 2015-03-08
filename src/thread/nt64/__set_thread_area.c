#include <errno.h>
#include "pthread_impl.h"

int __set_thread_area(void * p)
{
	struct pthread ** ptlca;

	ptlca = __psx_tlca();
	if (!ptlca) return -ESRCH;

	*ptlca = p;
	return 0;
}
