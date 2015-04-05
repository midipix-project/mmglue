#include "pthread_impl.h"
#include <threads.h>
#include "libc.h"

pthread_t pthread_self()
{
	return __pthread_self();
}

weak_alias(pthread_self, thrd_current);
