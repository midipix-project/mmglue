# flavor_app_linking_all_static.mk: handling of frontend linking options.
# this file is covered by COPYING.SOFORT.

package-app:	static-app
app:		PACKAGE_APP = $(STATIC_APP)
app-tag:	PACKAGE_APP = $(STATIC_APP)
app.tag:	$(STATIC_APP)
