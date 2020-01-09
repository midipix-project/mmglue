# version.mk: handling of shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

include $(PROJECT_DIR)/project/tagver.mk

CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_MAJOR=$(VER_MAJOR)
CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_MINOR=$(VER_MINOR)
CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_PATCH=$(VER_PATCH)

ifeq ($(AVOID_VERSION),yes)

VER_XYZ		=
VER_SONAME	=

package-shared-soname:
package-shared-solink:
package-install-soname:
package-install-solink:

else

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

# libfoo.so.x (symlink)
ifeq ($(OS_SONAME),symlink)
$(SHARED_SONAME):	$(SHARED_LIB)
			rm -f $@.tmp
			ln -s $(DSO_VER) $@.tmp
			mv $@.tmp $@

install-soname:		install-lib
			rm -f $(SHARED_SONAME).tmp
			ln -s $(DSO_VER) $(SHARED_SONAME).tmp
			mv $(SHARED_SONAME).tmp $(DESTDIR)$(LIBDIR)/$(DSO_SONAME)
endif


# libfoo.so.x (copy)
ifeq ($(OS_SONAME),copy)
install-soname:		install-lib
			cp $(SHARED_LIB) $(DESTDIR)$(LIBDIR)/$(DSO_SONAME)

$(SHARED_SONAME):	$(SHARED_LIB)
			cp $(SHARED_LIB) $(SHARED_SONAME)
endif

endif
