# flavor.mk: top-level handling of build flavors.
# this file is covered by COPYING.SOFORT.

include $(PROJECT_DIR)/sofort/exrules/$(OS_DSO_EXRULES).mk

include $(PROJECT_DIR)/sofort/core/_flavor/flavor_static_library_$(STATIC_LIBRARY_OPT).mk
include $(PROJECT_DIR)/sofort/core/_flavor/flavor_shared_library_$(SHARED_LIBRARY_OPT).mk

include $(PROJECT_DIR)/sofort/core/_flavor/flavor_app_frontend_$(APP_FRONTEND_OPT).mk
include $(PROJECT_DIR)/sofort/core/_flavor/flavor_app_linking_$(APP_LINKING_OPT).mk

include $(PROJECT_DIR)/sofort/core/_flavor/flavor_install_headers_$(INSTALL_HEADERS_OPT).mk
