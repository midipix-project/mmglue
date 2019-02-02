#include <unistd.h>
#include <stdint.h>
#include "crtinit.h"
#include "psxglue.h"

const int __hidden __crtopt_vrfs = __PSXOPT_VRFS;

/* pty server root-relative name */
const unsigned short __hidden __ctty[] = {'n','t','c','t','t','y',
                                 '.','e','x','e',0};
