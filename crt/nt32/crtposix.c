/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <unistd.h>
#include <stdint.h>
#include "crtinit.h"
#include "psxglue.h"

const int __hidden __crtopt_posix = __PSXOPT_POSIX;
