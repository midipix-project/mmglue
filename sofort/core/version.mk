# version.mk: handling of shared library versioning schemes.
# this file is covered by COPYING.SOFORT.

include $(PROJECT_DIR)/project/tagver.mk

CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_MAJOR=$(VER_MAJOR)
CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_MINOR=$(VER_MINOR)
CFLAGS_VERSION	+= -D$(VER_NAMESPACE)_TAG_VER_PATCH=$(VER_PATCH)

include $(PROJECT_DIR)/sofort/core/_version/version_$(VERSION_OPT).mk
