#define _BSD_SOURCE

#include <unistd.h>
#include "psxglue.h"
#include "pthread_impl.h"

extern const struct __ldso_vtbl * __ldso_vtbl;
extern const struct __psx_vtbl *  __psx_vtbl;

void __reset_tls(void)
{
	__ldso_vtbl->tlsreset();
}
