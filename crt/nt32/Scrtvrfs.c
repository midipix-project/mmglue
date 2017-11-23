#include <unistd.h>
#include <stdint.h>
#include "psxglue.h"

const int __crtopt_vrfs = __PSXOPT_VRFS;

/* pty server root-relative name */
static const unsigned short __ctty[] = {'n','t','c','t','t','y',
				        '.','e','x','e',0};
