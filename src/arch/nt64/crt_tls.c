/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under the Standard MIT License; see COPYING.MMGLUE.          */
/**************************************************************************/

#include <unistd.h>
#include <stdint.h>
#include <stddef.h>
#include "psxglue.h"
#include "pthread_arch.h"

typedef unsigned int __tls_word	__attribute__((mode(word)));
typedef unsigned int __tls_ptr	__attribute__((mode(pointer)));

struct __emutls_object
{
	__tls_word	size;
	__tls_word	align;
	ptrdiff_t	offset;
	void *		defval;
};

void * __emutls_get_address (struct __emutls_object * obj)
{
	int dsoidx = obj->align & 0xFFFF0000;
	struct __tlca_abi * tlca = (struct __tlca_abi *)__psx_tlca();
	return tlca->pthread_dtls[dsoidx >> 16] + obj->offset;
}

