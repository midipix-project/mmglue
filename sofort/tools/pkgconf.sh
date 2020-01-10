#!/bin/sh

# pkgconf.sh: generate a pkgconf manifest file.
# this file is covered by COPYING.SOFORT.

set -eu

# prefix, exec_prefix
if [ "$PKGCONF_PREFIX" = "$PKGCONF_EXEC_PREFIX" ]; then
	pkgconf_prefix="${PKGCONF_PREFIX}"
	pkgconf_exec_prefix='${prefix}'
else
	pkgconf_prefix="${PKGCONF_PREFIX}"
	pkgconf_exec_prefix="${PKGCONF_EXEC_PREFIX}"
fi


# (relative) includedir
if [ -z "$PKGCONF_INCLUDEDIR" ]; then
	pkgconf_includedir=
	pkgconf_cflags=
else
	prefix=$(dirname "$PKGCONF_INCLUDEDIR")
	base=$(basename "$PKGCONF_INCLUDEDIR")

	if [ "$prefix" = '/' ]; then
		prefix=
	fi

	if [ "$prefix/$base" = "$PKGCONF_PREFIX/$base" ]; then
		pkgconf_includedir='${prefix}/'"${base}"
		pkgconf_cflags='-I${includedir}'
	else
		pkgconf_includedir="${PKGCONF_INCLUDEDIR}"
		pkgconf_cflags='-I${includedir}'
	fi
fi


# (relative) libdir (blank unless needed)
if [ -z "$PKGCONF_LIBDIR" ]; then
	pkgconf_libdir=
else
	prefix=$(dirname "$PKGCONF_LIBDIR")
	base=$(basename "$PKGCONF_LIBDIR")

	if [ "$prefix" = '/' ]; then
		prefix=
	fi

	if [ "$prefix/$base" = "$PKGCONF_EXEC_PREFIX/$base" ]; then
		pkgconf_libdir='${exec_prefix}/'"${base}"
	else
		pkgconf_libdir='${prefix}/'"${PKGCONF_LIBDIR}"
	fi
fi


# ldflags (--libs)
if [ -n "$pkgconf_libdir" ] &&  [ -n "${PKGCONF_NAME}" ]; then
	pkgconf_ldflags="-L$pkgconf_libdir -l${PKGCONF_NAME}"
elif [ -n "${PKGCONF_NAME}" ]; then
	pkgconf_ldflags="-l${PKGCONF_NAME}"
else
	pkgconf_ldflags="-L$pkgconf_libdir"
fi


# cflags
if [ -n "$pkgconf_cflags" ] || [ -n "${PKGCONF_DEFS}" ]; then
	pkgconf_cflags="$pkgconf_cflags ${PKGCONF_DEFS}"
	pkgconf_cflags=$(printf '%s' "$pkgconf_cflags" | sed -e 's/^[ \t]*//g')
fi


# repo (optional)
if [ -z "${PKGCONF_REPO}" ]; then
	pkgconf_repo='#'
else
	pkgconf_repo="Repo:        ${PKGCONF_REPO}"
fi

# patches (optional)
if [ -z "${PKGCONF_PSRC}" ]; then
	pkgconf_psrc='#'
else
	pkgconf_psrc="Patches:     ${PKGCONF_PSRC}"
fi

# distro (optional)
if [ -z "${PKGCONF_DURL}" ]; then
	pkgconf_durl='#'
else
	pkgconf_durl="Distro:      ${PKGCONF_DURL}"
fi

# bug reports (optional)
if [ -z "${PKGCONF_BUGS}" ]; then
	pkgconf_bugs='#'
else
	pkgconf_bugs="Bug reports: ${PKGCONF_BUGS}"
fi

# project home page (optional)
if [ -z "${PKGCONF_HOME}" ]; then
	pkgconf_home='#'
else
	pkgconf_home="Home page:   ${PKGCONF_HOME}"
fi


# output (without trailing spaces)
cat << _EOF | grep -v '^#' | sed 's/[ \t]*$//'
###
prefix=$pkgconf_prefix
exec_prefix=$pkgconf_exec_prefix
includedir=$pkgconf_includedir
libdir=$pkgconf_libdir

Name:        ${PKGCONF_NAME}
Description: ${PKGCONF_DESC}
URL:         ${PKGCONF_USRC}
Version:     ${PKGCONF_VERSION}
$pkgconf_repo
$pkgconf_psrc
$pkgconf_durl
$pkgconf_bugs
$pkgconf_home

Cflags:      $pkgconf_cflags
Libs:        $pkgconf_ldflags
###
_EOF

# all done
exit 0
