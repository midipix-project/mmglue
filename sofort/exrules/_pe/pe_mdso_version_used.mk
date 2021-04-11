# pe_mdso_version_used.mk: PE shared library rules for targets using mdso.
# this file is covered by COPYING.SOFORT.

$(IMPLIB_SONAME):	$(IMPLIB_DEF)
			$(MDSO) -m $(CC_BITS) -i $(IMPLIB_SONAME) -n $(DSO_SONAME) $(IMPLIB_DEF)
