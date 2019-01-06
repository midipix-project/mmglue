# alltypes.h, syscall.h
ALLTYPES_H      = build/include/bits/alltypes.h
SYSCALL_H       = build/include/bits/syscall.h

ARCH_GEN_H      = $(ALLTYPES_H) $(SYSCALL_H)

ALLTYPES_DEPS   = \
		$(PORT_DIR)/arch/$(ARCH)/bits/alltypes.h.in \
		$(SOURCE_DIR)/include/alltypes.h.in \
		$(SOURCE_DIR)/tools/mkalltypes.sed

$(ALLTYPES_H):	build/headers.tag $(ALLTYPES_DEPS)
		sed -f $(SOURCE_DIR)/tools/mkalltypes.sed \
			$(PORT_DIR)/arch/$(ARCH)/bits/alltypes.h.in \
			$(SOURCE_DIR)/include/alltypes.h.in > $@

syscall-copy:	$(PORT_DIR)/arch/$(ARCH)/bits/syscall.h build/headers.tag
		cp $< $(SYSCALL_H)

syscall-gen:	$(PORT_DIR)/arch/$(ARCH)/bits/syscall.h.in build/headers.tag
		cp $< $(SYSCALL_H).tmp
		sed -n -e 's/__NR_/SYS_/p' < $< >> $(SYSCALL_H).tmp
		mv $(SYSCALL_H).tmp $(SYSCALL_H)

$(SYSCALL_H):	syscall-arch



# build/include
build/headers.tag:
		mkdir -p build/include
		mkdir -p build/include/bits
		touch $@

clean-headers:
		rm -f $(ARCH_GEN_H)
		rm -f $(SYSCALL_H).tmp
		rmdir build/include/bits 2>/dev/null || true
		rmdir build/include      2>/dev/null || true
		rm -f build/headers.tag

clean:		clean-headers

.PHONY:		syscall-arch
.PHONY:		syscall-copy
.PHONY:		syscall-gen
.PHONY:		clean-headers
