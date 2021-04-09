# flavor_app_linking_all_shared.mk: handling of frontend linking options.
# this file is covered by COPYING.SOFORT.

package-app:	shared-app
app:		PACKAGE_APP = $(SHARED_APP)
app-tag:	PACKAGE_APP = $(SHARED_APP)
app.tag:	$(SHARED_APP)
