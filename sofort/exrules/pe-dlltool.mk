include $(PROJECT_DIR)/sofort/exrules/pe-common.mk

$(IMPLIB_VER):		$(IMPLIB_DEF)
			$(DLLTOOL) -l $(IMPLIB_VER) -d $(IMPLIB_DEF) -D $(DSO_VER)

ifeq ($(AVOID_VERSION),yes)

else

$(IMPLIB_SONAME):	$(IMPLIB_DEF)
			$(DLLTOOL) -l $(IMPLIB_SONAME) -d $(IMPLIB_DEF) -D $(DSO_SONAME)

endif

include $(PROJECT_DIR)/sofort/exrules/pe-version.mk
