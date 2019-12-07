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
