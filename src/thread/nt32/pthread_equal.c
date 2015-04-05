#include "../pthread_equal.c"

int __pthread_equal_impl(pthread_t a, pthread_t b)
{
	return thrd_equal(a,b);
}
