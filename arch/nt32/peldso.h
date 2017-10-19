#ifndef _PELDSO_H_
#define _PELDSO_H_

/* ldso flags (pemagine)*/
#define PE_LDSO_INTEGRAL_ONLY		0x00000000
#define PE_LDSO_DEFAULT_EXECUTABLE	0x00000001
#define PE_LDSO_STANDALONE_EXECUTABLE	0x00000002

/* error status (ntapi) */
#define NT_STATUS_NOINTERFACE		0xC00002B9

/* rtdata guid (ntapi) */
#define NT_PROCESS_GUID_RTDATA		{0x3e43ec84,0x1af1,0x4ede,{0xac,0xd8,0xc3,0xd9,0x20,0xaf,0xc8,0x68}}

/* abi guid */
struct __guid {
	unsigned int	data1;
	unsigned short	data2;
	unsigned short	data3;
	unsigned char	data4[8];
};

/* loader interfaces, statically linked (libldso.a) */
__attribute__((__visibility__("hidden"))) int    __ldso_terminate_current_process(
	int			estatus);

__attribute__((__visibility__("hidden"))) void * __ldso_get_procedure_address(
	const void *		base,
	const char *		name);

__attribute__((__visibility__("hidden"))) int    __ldso_load_framework_loader_ex(
	void **			baseaddr,
	void **			hroot,
	void **			hdsodir,
	const struct __guid *	abi,
	const unsigned short *	basename,
	const unsigned short *	rrelname,
	void *			refaddr,
	unsigned long *		buffer,
	unsigned int		bufsize,
	unsigned int		flags,
	unsigned int *		sysflags);

__attribute__((__visibility__("hidden"))) int    __ldso_load_framework_library(
	void **			baseaddr,
	void *			hat,
	const unsigned short *	atrelname,
	unsigned long *		buffer,
	unsigned int		bufsize,
	unsigned int *		sysflags);

#endif
