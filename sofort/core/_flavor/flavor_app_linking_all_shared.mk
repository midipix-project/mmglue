# flavor_app_linking_all_shared.mk: handling of frontend linking options.
# this file is covered by COPYING.SOFORT.

PACKAGE_APP   = $(SHARED_APP)

package-app:	shared-app
app.tag:	$(SHARED_APP)
