#ifndef _SYS_CMD_H
#define _SYS_CMD_H

#ifdef __cplusplus
extern "C" {
#endif

#define __NEED_size_t

#include <bits/alltypes.h>

/***************************************************************************/
/* int (*cmd_args_to_argv)(                                                */
/*      const char * args,                                                 */
/*      char * argbuf, size_t buflen,                                      */
/*      char ** argv, size_t nptrs);                                       */
/*                                                                         */
/* arguments:                                                              */
/*   args:       command to parse                                          */
/*   argbuf:     buffer to receive the corresponding sequence of           */
/*                 null-terminated arguments.                              */
/*   buflen:     size of argbuf, including final null-terminator.          */
/*   argv:       argument vector to receive pointers to the above          */
/*                 null-terminated arguments.                              */
/*   nptrs:      number of available argv pointers, including              */
/*                 including the terminating null pointer.                 */
/*                                                                         */
/* return value:                                                           */
/*   zero upon successful parsing and buffer initialization                */
/*   negative value returned upon failure, which is the actual value       */
/*     returned by the underlying system call; accordingly, errno          */
/*     is _not_ set by the above interface.                                */
/*                                                                         */
/* implementation:                                                         */
/*   the above interface is async-safe, thread-safe, and re-entrant.       */
/*                                                                         */
/***************************************************************************/

int __cmd_args_to_argv(const char *, char *, size_t, char **, size_t);

#ifdef __cplusplus
}
#endif

#endif
