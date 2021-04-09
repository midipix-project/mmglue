# version_used.mk: handling of shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

VER_XYZ		= .$(VER_MAJOR).$(VER_MINOR).$(VER_PATCH)
VER_SONAME	= .$(VER_MAJOR)

package-shared-soname:	shared-soname
package-shared-solink:	shared-solink
package-install-soname:	install-soname
package-install-solink:	install-solink



# libfoo.so (common)
install-solink:		install-lib
			rm -f $(SHARED_SOLINK).tmp
			ln -s $(DSO_VER) $(SHARED_SOLINK).tmp
			mv $(SHARED_SOLINK).tmp $(DESTDIR)$(LIBDIR)/$(DSO_SOLINK)

$(SHARED_SOLINK):	$(SHARED_LIB)
			rm -f $@.tmp
			ln -s $(DSO_VER) $@.tmp
			mv $@.tmp $@

# libfoo.so.x (symlink or copy)
include $(PROJECT_DIR)/sofort/core/_version/_soname/version_soname_$(OS_SONAME).mk
