# pe-mdso.mk: PE shared library rules for targets using mdso.
# this file is covered by COPYING.SOFORT.

include $(PROJECT_DIR)/sofort/exrules/pe-common.mk

$(IMPLIB_VER):		$(IMPLIB_DEF)
			$(MDSO) -m $(CC_BITS) -i $(IMPLIB_VER) -n $(DSO_VER) -l $(DSO_LIBPATH) $<

ifeq ($(AVOID_VERSION),yes)

else

$(IMPLIB_SONAME):	$(IMPLIB_DEF)
			$(MDSO) -m $(CC_BITS) -i $(IMPLIB_SONAME) -n $(DSO_SONAME) $(IMPLIB_DEF)

endif

include $(PROJECT_DIR)/sofort/exrules/pe-version.mk
