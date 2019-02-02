#include <unistd.h>
#include <stdint.h>
#include "crtinit.h"
#include "psxglue.h"

const int __hidden __crtopt_ldso = __PSXOPT_LDSO;

/* pty server root-relative name */
const unsigned short __hidden __ctty[] = {'b','i','n','\\',
                                 'n','t','c','t','t','y',
                                  '.','e','x','e',0};
