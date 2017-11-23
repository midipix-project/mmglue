#include <unistd.h>
#include <stdint.h>
#include "psxglue.h"

const int __crtopt_ldso = __PSXOPT_LDSO;

/* pty server root-relative name */
static const unsigned short __ctty[] = {'b','i','n','\\',
				        'n','t','c','t','t','y',
				        '.','e','x','e',0};
