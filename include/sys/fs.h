#ifndef _SYS_FS_H
#define _SYS_FS_H

#ifdef __cplusplus
extern "C" {
#endif

#define __NEED_size_t

#include <bits/alltypes.h>

/***************************************************************************/
/* int (*__fs_path_fn)(int fdat, const char * path, int options,           */
/*      char * buffer, size_t buflen);                                     */
/*                                                                         */
/* resolve and obtain the full path using one of four supported notations: */
/*                                                                         */
/* __fs_rpath(): root-relative notation (e.g. /bar)                        */
/* __fs_apath(): root-based absolute notation (e.g. /dev/fs/c/foo/bar)     */
/* __fs_npath(): native tool notation (e.g. C:\foo\bar)                    */
/* __fs_dpath(): native driver notation (e.g. \Device\Harddisk0\foo\bar    */
/*                                                                         */
/* arguments:                                                              */
/*   fdat:       open at file descriptor                                   */
/*   path:       path to resolve, absolute or relative                     */
/*   options:    options to be passed to the internal path resolution      */
/*                 interface, for instance O_DIRECTORY|O_NOFOLLOW          */
/*   buffer:     buffer to receive the fully resolved path                 */
/*   buflen:     size of buffer, including null termination.               */
/*                                                                         */
/* return value:                                                           */
/*   zero upon successful resolution and buffer initialization             */
/*   negative value returned upon failure, which is the actual value       */
/*     returned by the underlying system call; accordingly, errno          */
/*     is _not_ set by any of the above interfaces.                        */
/*                                                                         */
/* implementation:                                                         */
/*   the above interfaces are async-safe, thread-safe, and re-entrant.     */
/*                                                                         */
/***************************************************************************/

int __fs_rpath(int, const char *, int, char *, size_t);
int __fs_apath(int, const char *, int, char *, size_t);
int __fs_npath(int, const char *, int, char *, size_t);
int __fs_dpath(int, const char *, int, char *, size_t);

#ifdef __cplusplus
}
#endif

#endif
