# flavor_app_linking_default.mk: handling of frontend linking options.
# this file is covered by COPYING.SOFORT.

package-app:	default-app
app:		PACKAGE_APP = $(DEFAULT_APP)
app-tag:	PACKAGE_APP = $(DEFAULT_APP)
app.tag:	$(DEFAULT_APP)
