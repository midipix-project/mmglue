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
