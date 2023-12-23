/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <sys/fs.h>
#include "syscall.h"

int __fs_rpath(int fdat, const char * path, int options,
		char * buffer, size_t buflen)
{
	return syscall(SYS_fs_rpath,fdat,path,options,buffer,buflen);
}

int __fs_apath(int fdat, const char * path, int options,
		char * buffer, size_t buflen)
{
	return syscall(SYS_fs_apath,fdat,path,options,buffer,buflen);
}

int __fs_npath(int fdat, const char * path, int options,
		char * buffer, size_t buflen)
{
	return syscall(SYS_fs_npath,fdat,path,options,buffer,buflen);
}

int __fs_dpath(int fdat, const char * path, int options,
		char * buffer, size_t buflen)
{
	return syscall(SYS_fs_dpath,fdat,path,options,buffer,buflen);
}

int __fs_mkdir(int fdat, const char * path, mode_t mode, uint32_t ace_flags)
{
	return syscall(SYS_fs_mkdir,fdat,path,mode,ace_flags);
}

int __fs_chmod(int fdat, const char * path, mode_t mode, int flags, uint32_t ace_flags)
{
	return syscall(SYS_fs_chmod,fdat,path,mode,flags,ace_flags);
}

int __fs_tmpfile(int flags)
{
	return syscall(SYS_fs_tmpfile,flags);
}

int __fs_tmpdir(int flags)
{
	return syscall(SYS_fs_tmpdir,flags);
}
