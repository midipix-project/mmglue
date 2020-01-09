# default.mk: default shared library rules.
# this file is covered by COPYING.SOFORT.

DSO_REF_VER      = $(SHARED_LIB)
DSO_REF_SONAME   = $(SHARED_SONAME)
DSO_REF_SOLINK   = $(SHARED_SOLINK)

LDFLAGS_SHARED  += -Wl,-soname
LDFLAGS_SHARED  += -Wl,$(DSO_SONAME)

.PHONY:         $(IMPLIB_DEF) $(IMPLIB_VER) $(IMPLIB_SONAME) $(IMPLIB_SOLINK)
