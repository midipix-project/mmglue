# pkgconf.mk: rules for pkgconf manifest generation.
# this file is covered by COPYING.SOFORT.

PKGCONF_VERSION = $(VER_MAJOR).$(VER_MINOR).$(VER_PATCH)

build/$(PACKAGE).pc: .pkgconf dirs.tag

build/$(PACKAGE).pc:
	@touch $@
	@chmod 0644 $@
		PKGCONF_NAME='$(PKGNAME)' \
		PKGCONF_DESC='$(PKGDESC)' \
		PKGCONF_USRC='$(PKGUSRC)' \
		PKGCONF_REPO='$(PKGREPO)' \
		PKGCONF_PSRC='$(PKGPSRC)' \
		PKGCONF_DURL='$(PKGDURL)' \
		PKGCONF_BUGS='$(PKGBUGS)' \
		PKGCONF_HOME='$(PKGHOME)' \
		PKGCONF_DEFS='$(PKGDEFS)' \
		PKGCONF_LIBS='$(PKGLIBS)' \
					  \
		PKGCONF_EXEC_PREFIX='$(EXEC_PREFIX)' \
		PKGCONF_PREFIX='$(PREFIX)'           \
		PKGCONF_LIBDIR='$(LIBDIR)'           \
		PKGCONF_INCLUDEDIR='$(INCLUDEDIR)'   \
		PKGCONF_VERSION='$(PKGCONF_VERSION)' \
	$(PROJECT_DIR)/sofort/tools/pkgconf.sh > $@

install-pkgconf: build/$(PACKAGE).pc
	mkdir -p $(DESTDIR)$(LIBDIR)/pkgconfig
	cp -p build/$(PACKAGE).pc    $(DESTDIR)$(LIBDIR)/pkgconfig

install-shared: install-pkgconf

install-static: install-pkgconf

.PHONY: .pkgconf install-pkgconf
