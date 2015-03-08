#include <stddef.h>

ptrdiff_t __tlsdesc_static(void)
{
	return 0;
}

ptrdiff_t  __tlsdesc_dynamic(void) __attribute__((alias("__tlsdesc_static")));
