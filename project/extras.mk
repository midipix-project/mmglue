./src/internal/version.o:	build/version.h
./src/internal/version.lo:	build/version.h

# libc.so
SHARED_OBJS      += $(LDSO_OBJS)
SHARED_LIB_DEPS  += $(LIBC_DEPS)

LDFLAGS_COMMON   += -nostdlib
LDFLAGS_COMMON   += -Wl,-Bsymbolic-functions
LDFLAGS_COMMON   += -Wl,--sort-common
LDFLAGS_COMMON   += -Wl,--gc-sections
LDFLAGS_COMMON   += -Wl,--no-undefined
LDFLAGS_COMMON   += -Wl,--exclude-libs=ALL

LDFLAGS_COMMON   += -Wl,-e              -Wl,_dlstart
LDFLAGS_COMMON   += -Wl,--sort-section  -Wl,alignment

ifeq ($(CC_BINFMT),ELF)
LDFLAGS_COMMON   += -Wl,--hash-style    -Wl,both
endif

# common cflags
CFLAGS_COMMON    += -fdata-sections
CFLAGS_COMMON    += -ffunction-sections
CFLAGS_COMMON    += -fno-unwind-tables
CFLAGS_COMMON    += -fno-asynchronous-unwind-tables
CFLAGS_COMMON    += -frounding-math
CFLAGS_COMMON    += -fexcess-precision=standard

# assembler cflags
ifeq ($(CC_BINFMT),ELF)
CFLAGS_ASM       += -Wa,--noexecstack
CFLAGS_CONFIG    += $(CFLAGS_ASM)
endif

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

# target libdir
$(DESTDIR)$(LIBDIR):
	mkdir -p $@

# empty libs
LIBC_EMPTY_LIBS_NAMES    = m rt dl crypt util pthread xnet resolv
LIBC_EMPTY_LIBS          = $(LIBC_EMPTY_LIBS_NAMES:%=lib/lib%.a)
LIBC_EMPTY_LIBS_TARGET   = $(LIBC_EMPTY_LIBS_NAMES:%=$(DESTDIR)$(LIBDIR)/lib%.a)

shared-lib:                $(LIBC_EMPTY_LIBS)
static-lib:                $(LIBC_EMPTY_LIBS)

$(DESTDIR)$(LIBDIR)/%.a: lib/%.a $(DESTDIR)$(LIBDIR)
	cp $< $@.tmp
	chmod 0644 $@.tmp
	mv $@.tmp $@

install-shared:	$(LIBC_EMPTY_LIBS_TARGET)
install-static:	$(LIBC_EMPTY_LIBS_TARGET)

# crt objects
CRT_OBJS_REFS   = $(subst $(ARCH)/,,$(CRT_OBJS))
CRT_OBJS_TARGET = $(subst ./crt/,$(DESTDIR)$(LIBDIR)/,$(CRT_OBJS_REFS))

$(DESTDIR)$(LIBDIR)/%.o: crt/$(ARCH)/%.o $(DESTDIR)$(LIBDIR)
	cp $< $@.tmp
	chmod 0644 $@.tmp
	mv $@.tmp $@

$(DESTDIR)$(LIBDIR)/%.o: crt/%.o $(DESTDIR)$(LIBDIR)
	cp $< $@.tmp
	chmod 0644 $@.tmp
	mv $@.tmp $@

install-shared:	$(CRT_OBJS_TARGET)
install-static:	$(CRT_OBJS_TARGET)
