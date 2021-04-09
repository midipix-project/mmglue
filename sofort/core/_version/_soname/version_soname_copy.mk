# version_soname_copy.mk: handling of shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

install-soname:		install-lib
			cp $(SHARED_LIB) $(DESTDIR)$(LIBDIR)/$(DSO_SONAME)

$(SHARED_SONAME):	$(SHARED_LIB)
			cp $(SHARED_LIB) $(SHARED_SONAME)
