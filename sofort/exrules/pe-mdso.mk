# pe-mdso.mk: PE shared library rules for targets using mdso.
# this file is covered by COPYING.SOFORT.

include $(PROJECT_DIR)/sofort/exrules/pe-common.mk

$(IMPLIB_VER):	$(IMPLIB_DEF)
		$(MDSO) -m $(CC_BITS) -i $(IMPLIB_VER) -n $(DSO_VER) -l $(DSO_LIBPATH) $(IMPLIB_DEF)

include $(PROJECT_DIR)/sofort/exrules/_pe/pe_mdso_version_$(VERSION_OPT).mk

include $(PROJECT_DIR)/sofort/exrules/pe-version.mk
