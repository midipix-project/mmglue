ifeq ($(OS),midipix)

CFLAGS_CONFIG  += -I\$(PROJECT_DIR)/include

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

TARGET_SYS_HEADERS = \
	$(PROJECT_DIR)/include/sys/cmd.h \
	$(PROJECT_DIR)/include/sys/debug.h \
	$(PROJECT_DIR)/include/sys/fs.h \
	$(PROJECT_DIR)/include/sys/ldso.h \
	$(PROJECT_DIR)/include/sys/unwind.h \

install-headers: install-target-sys-headers

headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/atomic.h
headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/peldso.h
headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/psxglue.h
headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/psxseh.h

headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/atomic_arch.h
headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/pthread_arch.h
headers.tag: $(PROJECT_DIR)/arch/$(ARCH)/syscall_arch.h

else

CFLAGS_CONFIG  += -fno-asynchronous-unwind-tables

endif

install-target-sys-headers: $(TARGET_SYS_HEADERS)
	mkdir -p $(DESTDIR)$(INCLUDEDIR)/sys
	cp    -p $(TARGET_SYS_HEADERS)       $(DESTDIR)$(INCLUDEDIR)/sys



# fallback alltypes.sed
build/alltypes.sed:
	touch $@

clean-alltypes-sed:
	rm -f build/alltypes.sed

clean:	clean-alltypes-sed

.PHONY:	clean-alltypes-sed
