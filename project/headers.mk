# build/version.h
build/version.h:$(wildcard $(SOURCE_DIR)/VERSION $(SOURCE_DIR)/.git/index) dirs.tag
		printf '#define VERSION "%s"\n' \
		       "$$(cd $(SOURCE_DIR); $(SHELL) ./tools/version.sh)" > $@

# alltypes.h, syscall.h
build/include/bits/:
		mkdir -p $@

ALLTYPES_H      = build/include/bits/alltypes.h
SYSCALL_H       = build/include/bits/syscall.h

ARCH_GEN_H      = $(ALLTYPES_H) $(SYSCALL_H)

ALLTYPES_DEPS   = \
		$(PORT_DIR)/arch/$(ARCH)/bits/alltypes.h.in \
		$(ALLTYPES_SED) \
		$(SOURCE_DIR)/include/alltypes.h.in \
		$(SOURCE_DIR)/tools/mkalltypes.sed \
		| build/include/bits/

$(ALLTYPES_H):	$(ALLTYPES_DEPS)
		sed -f $(ALLTYPES_SED) \
		    -f $(SOURCE_DIR)/tools/mkalltypes.sed \
			$(PORT_DIR)/arch/$(ARCH)/bits/alltypes.h.in \
			$(SOURCE_DIR)/include/alltypes.h.in > $@

build/syscall_h.tag:
		touch $@
		touch $(SYSCALL_H)

build/syscall-copy.tag: | build/include/bits/
build/syscall-copy.tag: $(PORT_DIR)/arch/$(ARCH)/bits/syscall.h
		cp $< $(SYSCALL_H)
		touch $@

build/syscall-gen.tag: | build/include/bits/
build/syscall-gen.tag: $(PORT_DIR)/arch/$(ARCH)/bits/syscall.h.in
		cp $< $(SYSCALL_H).tmp
		sed -n -e 's/__NR_/SYS_/p' < $< >> $(SYSCALL_H).tmp
		mv $(SYSCALL_H).tmp $(SYSCALL_H)
		touch $@

$(SYSCALL_H):	build/syscall_h.tag


# arch headers
libc_bits_h     = $(sort $(wildcard $(SOURCE_DIR)/arch/generic/bits/*.h))
port_bits_h     = $(sort $(wildcard $(PORT_DIR)/arch/$(ARCH)/bits/*.h))
port_substs_h   = $(subst $(PORT_DIR)/arch/$(ARCH)/, \
		          $(SOURCE_DIR)/arch/generic/,\
		   $(port_bits_h))

ARCH_HEADERS    = $(port_bits_h) $(filter-out $(port_substs_h), $(libc_bits_h))

src_bits_h      = $(subst $(SOURCE_DIR)/arch/generic/,build/include/,\
		    $(subst $(PORT_DIR)/arch/$(ARCH)/,build/include/, \
		      $(ARCH_HEADERS)))

dst_bits_h      = $(ARCH_GEN_H:build/include/%=$(DESTDIR)$(INCLUDEDIR)/%)
dst_bits_h     += $(src_bits_h:build/include/%=$(DESTDIR)$(INCLUDEDIR)/%)


# libc headers
src_header_dirs = $(filter %/,$(wildcard $(SOURCE_DIR)/include/*/))
dst_header_dirs = $(src_header_dirs:$(SOURCE_DIR)/include/%=$(DESTDIR)$(INCLUDEDIR)/%)

src_c_headers   = $(sort $(wildcard $(SOURCE_DIR)/include/*.h))
src_c_headers  += $(sort $(wildcard $(SOURCE_DIR)/include/*/*.h))

dst_c_headers   = $(subst $(SOURCE_DIR)/include/,  \
		          $(DESTDIR)$(INCLUDEDIR)/, \
		    $(src_c_headers))

$(dst_header_dirs):
			mkdir -p $@

$(src_bits_h):		build/headers.tag

$(DESTDIR)$(INCLUDEDIR)/bits/:
			mkdir -p $@

$(DESTDIR)$(INCLUDEDIR)/bits/%.h: build/include/bits/%.h $(DESTDIR)$(INCLUDEDIR)/bits/
			cp $< $@.tmp
			chmod 0644 $@.tmp
			mv $@.tmp $@

$(DESTDIR)$(INCLUDEDIR)/%.h: | $(dst_header_dirs)
$(DESTDIR)$(INCLUDEDIR)/%.h: $(SOURCE_DIR)/include/%.h
			cp -p $< $@.tmp
			chmod 0644 $@.tmp
			mv $@.tmp $@

install-arch-headers:	headers.tag $(ARCH_GEN_H) $(src_bits_h) $(dst_bits_h)

install-libc-headers:	headers.tag $(dst_header_dirs) $(dst_c_headers)

install-headers:	install-arch-headers install-libc-headers


# build/include
build/headers.tag:	| build/include/bits/
build/headers.tag:	$(ARCH_HEADERS)
			cp $(ARCH_HEADERS) build/include/bits/
			touch $@

headers.tag:		build/headers.tag $(ARCH_GEN_H)
			grep -v '^@@@' build/include/bits/ioctl.h \
				> build/include/bits/ioctl.h.tmp
			grep 'struct winsize' $(SOURCE_DIR)/include/sys/ioctl.h \
				|| sed 's/^@@@//g' build/include/bits/ioctl.h     \
					> build/include/bits/ioctl.h.tmp
			mv build/include/bits/ioctl.h.tmp build/include/bits/ioctl.h
			touch $@

clean-headers:
		rm -f $(ARCH_GEN_H)
		rm -f $(src_bits_h)
		rm -f $(SYSCALL_H).tmp
		rm -f build/version.h
		rmdir build/include/bits 2>/dev/null || true
		rmdir build/include      2>/dev/null || true
		rm -f build/headers.tag
		rm -f build/syscall-copy.tag
		rm -f build/syscall-gen.tag
		rm -f build/syscall_h.tag
		rm -f headers.tag

clean:		clean-headers

.PHONY:		syscall-arch
.PHONY:		syscall-copy
.PHONY:		syscall-gen
.PHONY:		clean-headers
