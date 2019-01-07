ifeq ($(OS),midipix)

src/env/__libc_start_main.lo: CFLAGS_SHARED += -USHARED

endif
