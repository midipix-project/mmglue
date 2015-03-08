#include <stddef.h>
#include <dlfcn.h>
#include <link.h>

typedef int __ldso_phdr_callback(struct dl_phdr_info * info, size_t size, void * data);

int dl_iterate_phdr(__ldso_phdr_callback * callback, void * data)
{
	return -1;
}
