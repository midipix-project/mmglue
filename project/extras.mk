./src/internal/version.o:	build/version.h
./src/internal/version.lo:	build/version.h

# libc.so
SHARED_OBJS      += $(LDSO_OBJS)

LDFLAGS_COMMON   += -nostdlib
LDFLAGS_COMMON   += -Wl,-Bsymbolic-functions
LDFLAGS_COMMON   += -Wl,--sort-common
LDFLAGS_COMMON   += -Wl,--gc-sections
LDFLAGS_COMMON   += -Wl,--no-undefined
LDFLAGS_COMMON   += -Wl,--exclude-libs=ALL

LDFLAGS_COMMON   += -Wl,-e              -Wl,_dlstart
LDFLAGS_COMMON   += -Wl,--hash-style    -Wl,both
LDFLAGS_COMMON   += -Wl,--sort-section  -Wl,alignment

SHARED_LIB_DEPS  += -lgcc -lgcc_eh

# common cflags
CFLAGS_COMMON    += -fdata-sections
CFLAGS_COMMON    += -ffunction-sections
CFLAGS_COMMON    += -fno-unwind-tables
CFLAGS_COMMON    += -fno-asynchronous-unwind-tables
CFLAGS_COMMON    += -frounding-math
CFLAGS_COMMON    += -fexcess-precision=standard

# memory modules
libc_mem_modules  = \
	./src/string/memcpy.c \
	./src/string/memmove.c \
	./src/string/memcmp.c   \
	./src/string/memset.c

libc_mem_objs     = $(libc_mem_modules:%.c=%.o)
libc_mem_lobjs    = $(libc_mem_modules:%.c=%.lo)

$(libc_mem_objs):   CFLAGS_CONFIG += -fno-tree-loop-distribute-patterns
$(libc_mem_lobjs):  CFLAGS_CONFIG += -fno-tree-loop-distribute-patterns
