# pe-common.mk: common PE shared library rules.
# this file is covered by COPYING.SOFORT.

DSO_REF_VER      = $(IMPLIB_VER)
DSO_REF_SONAME   = $(IMPLIB_SONAME)
DSO_REF_SOLINK   = $(IMPLIB_SOLINK)

LDFLAGS_IMPLIB	+= -Wl,--output-def
LDFLAGS_IMPLIB	+= -Wl,$(IMPLIB_DEF)

LDFLAGS_SONAME	+= -Wl,-soname
LDFLAGS_SONAME	+= -Wl,$(DSO_SONAME)
LDFLAGS_SHARED	+= $(LDFLAGS_SONAME)

DSO_LIBPATH	?= loader
PE_SUBSYSTEM	?= windows
LDFLAGS_COMMON	+= -Wl,--subsystem=$(PE_SUBSYSTEM)

implib:			implib-ver package-implib-soname package-implib-solink

implib-ver:		shared-lib $(IMPLIB_VER)

implib-soname:		shared-lib $(IMPLIB_SONAME)

implib-solink:		shared-lib $(IMPLIB_SOLINK)

$(IMPLIB_DEF):		shared-lib

install-implib:		install-implib-ver \
			package-install-implib-soname \
			package-install-implib-solink

install-implib-ver:	implib-ver
			mkdir -p $(DESTDIR)$(LIBDIR)
			cp $(IMPLIB_VER) $(DESTDIR)$(LIBDIR)

clean-implib:
			rm -f $(SHARED_LIB)
			rm -f $(IMPLIB_DEF)
			rm -f $(IMPLIB_VER)
			rm -f $(IMPLIB_SONAME)
			rm -f $(IMPLIB_SOLINK)
