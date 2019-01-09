ifeq ($(OS),midipix)

src/env/__libc_start_main.lo: CFLAGS_SHARED += -USHARED

SHARED_OBJS    += crt/$(ARCH)/crtn.o

LDFLAGS_CONFIG += -Wl,--exclude-symbols=_dlstart
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__syscall_vtbl
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__ldso_vtbl
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__psx_vtbl
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__teb_sys_idx
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__teb_libc_idx
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__vm_lock_impl
LDFLAGS_CONFIG += -Wl,--exclude-symbols=__vm_unlock_impl
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_feof_unlocked
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_ferror_unlocked
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_getc
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_getc_unlocked
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_putc
LDFLAGS_CONFIG += -Wl,--exclude-symbols=_IO_putc_unlocked
LDFLAGS_CONFIG += -Wl,--exclude-symbols=___errno_location

endif
