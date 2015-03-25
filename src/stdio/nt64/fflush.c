#include "../fflush.c"

int __fflush_unlocked_impl(FILE *f)
{
	return __fflush_unlocked(f);
}
