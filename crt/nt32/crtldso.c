/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

#include <unistd.h>
#include <stdint.h>
#include "crtinit.h"
#include "psxglue.h"
#include "peldso.h"

const int __hidden __crtopt_ldso = __PSXOPT_LDSO;

/* framework (rtdata) abi */
static const struct __guid  __ldsoabi  = NT_PROCESS_GUID_RTDATA;

/* loader root-relative name */
static const unsigned short __rrldso[] = {'l','i','b','\\',
				          'l','i','b','p','s','x','s','c','l',
				          '.','s','o',0};

/* libc root-relative name */
static const unsigned short __rrlibc[] = {'l','i','b','\\',
				          'l','i','b','c',
				          '.','s','o',0};

/* pty server root-relative name */
static const unsigned short __rrctty[] = {'b','i','n','\\',
				          'n','t','c','t','t','y',
				          '.','e','x','e',0};


static unsigned long	__attribute__((section(".dsodata")))
			__dsodata[65536/sizeof(unsigned long)];

void __hidden __libc_loader_init(void * __main, int flags)
{
	int		status;
	void *		hroot;
	void *		hdsodir;
	void *		ldsobase;
	void *		libcbase;
	int  		(*__psx_init)(
				int *,char ***,char ***,
				void *);
	void		(*__libc_entry_routine)(
				void *,void *,
				const unsigned short *,
				int);

	if ((status = __ldso_load_framework_loader_ex(
			&ldsobase,&hroot,&hdsodir,
			&__ldsoabi,
			0,__rrldso,__main,
			__dsodata,sizeof(__dsodata),
			PE_LDSO_DEFAULT_EXECUTABLE,
			&(unsigned int){0})))
		__ldso_terminate_current_process(status);

	if ((status = __ldso_load_framework_library(
			&libcbase,hroot,__rrlibc,
			__dsodata,sizeof(__dsodata),
			&(unsigned int){0})))
		__ldso_terminate_current_process(status);

	if (!(__psx_init = __ldso_get_procedure_address(
			ldsobase,"__psx_init")))
		__ldso_terminate_current_process(NT_STATUS_NOINTERFACE);

	if (!(__libc_entry_routine = __ldso_get_procedure_address(
			libcbase,"__libc_entry_routine")))
		__ldso_terminate_current_process(NT_STATUS_NOINTERFACE);

	__libc_entry_routine(__main,__psx_init,__rrctty,flags);
}
