#include "../libc.h"

/* todo: teach the linker to export weak symbols */
#undef  weak_alias
#define weak_alias(old,new) extern __typeof(old) new __attribute__((alias(#old)))

#include "../libc.c"
