# flavor_app_linking_all_static.mk: handling of frontend linking options.
# this file is covered by COPYING.SOFORT.

PACKAGE_APP   = $(STATIC_APP)

package-app:	static-app
app.tag:	$(STATIC_APP)
