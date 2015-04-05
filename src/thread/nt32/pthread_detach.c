#include "../pthread_detach.c"

int __pthread_detach_impl(pthread_t t)
{
	return thrd_detach(t);
}
