# version_soname_symlink.mk: handling of shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

$(SHARED_SONAME):	$(SHARED_LIB)
			rm -f $@.tmp
			ln -s $(DSO_VER) $@.tmp
			mv $@.tmp $@

install-soname:		install-lib
			rm -f $(SHARED_SONAME).tmp
			ln -s $(DSO_VER) $(SHARED_SONAME).tmp
			mv $(SHARED_SONAME).tmp $(DESTDIR)$(LIBDIR)/$(DSO_SONAME)
