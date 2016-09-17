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
	struct __tlca * tlca = (struct __tlca *)__psx_tlca();
	return tlca->pthread_dtls[dsoidx >> 16] + obj->offset;
}

