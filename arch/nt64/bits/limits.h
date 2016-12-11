#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
#define PAGE_SIZE	65536
#define LONG_BIT	64
#endif

#define LONG_MAX  0x7fffffffffffffffL
#define LLONG_MAX  0x7fffffffffffffffLL

#define _MIDIPIX_ABI    20170101
#define _MIDIPIX_XFI    20170101
#define _MIDIPIX_GDI    20170101
