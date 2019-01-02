ifneq ($(OS_DSO_EXRULES),)
include $(PROJECT_DIR)/sofort/exrules/$(OS_DSO_EXRULES).mk
endif

ifeq ($(DISABLE_STATIC),yes)
package-static:
package-install-static:
else
package-static:		static
package-install-static:	install-static
endif

ifeq ($(DISABLE_SHARED),yes)
package-shared:
package-install-shared:
else
package-shared:		shared
package-install-shared:	install-shared
endif



ifeq ($(DISABLE_FRONTEND),yes)
app-tag:
package-install-app:
package-install-extras:
else
app-tag:		package-app app.tag
package-install-app:	install-app
package-install-extras:	install-extras
endif



ifeq ($(ALL_STATIC),yes)

package-app:	static-app
app:		PACKAGE_APP = $(STATIC_APP)
app-tag:	PACKAGE_APP = $(STATIC_APP)
app.tag:	$(STATIC_APP)


else ifeq ($(ALL_SHARED),yes)

package-app:	shared-app
app:		PACKAGE_APP = $(SHARED_APP)
app-tag:	PACKAGE_APP = $(SHARED_APP)
app.tag:	$(SHARED_APP)


else

package-app:	default-app
app:		PACKAGE_APP = $(DEFAULT_APP)
app-tag:	PACKAGE_APP = $(DEFAULT_APP)
app.tag:	$(DEFAULT_APP)

endif



ifeq ($(CUSTOM_INSTALL_HEADERS),yes)

install-headers:install-headers-custom

else

install-headers:install-headers-default

endif
