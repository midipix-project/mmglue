#include "pthread_impl.h"
#include <threads.h>

void * __pthread_getspecific_impl(pthread_key_t k)
{
	return (__pthread_self())->tsd[k];
}
