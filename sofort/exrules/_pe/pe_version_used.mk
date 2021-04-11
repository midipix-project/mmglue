# pe_version_used.mk: handling of PE shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

package-implib-soname:		implib-soname
package-implib-solink:		implib-solink
package-install-implib-soname:	install-implib-soname
package-install-implib-solink:	install-implib-solink


$(IMPLIB_SOLINK):	$(IMPLIB_SONAME)
			rm -f $(IMPLIB_SOLINK).tmp
			ln -s $(IMP_SONAME) $(IMPLIB_SOLINK).tmp
			mv $(IMPLIB_SOLINK).tmp $(IMPLIB_SOLINK)

install-implib-soname:	implib-soname
			mkdir -p $(DESTDIR)$(LIBDIR)
			cp $(IMPLIB_SONAME) $(DESTDIR)$(LIBDIR)

install-implib-solink:	implib-soname
			mkdir -p $(DESTDIR)$(LIBDIR)
			rm -f $(IMPLIB_SOLINK).tmp
			ln -s $(IMP_SONAME) $(IMPLIB_SOLINK).tmp
			mv $(IMPLIB_SOLINK).tmp $(DESTDIR)$(LIBDIR)/$(IMP_SOLINK)
