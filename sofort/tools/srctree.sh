#!/bin/sh

# srctree.sh: support for out-of-tree builds in posix make mode.
# this file is covered by COPYING.SOFORT.

set -eu

usage()
{
cat << EOF >&2

Usage:
  --help              show this HELP message
  --srctree=SRCTREE   set source directory

EOF
exit 1
}


# one
workdir=$(pwd -P)
srctree=
argloop=


for arg ; do
	case "$arg" in
		--help)
			usage
			;;

		--srctree=*)
			srctree=${arg#*=}
			;;

		--)
			argloop='done'
			;;

		*)
			if [ -z "$argloop" ]; then
				printf 'Invalid option: %s\n' "$arg" >&2
				usage
			fi
			;;
	esac
done


# two
if [ -z "$srctree" ] ; then
	usage
fi

cd -- "$srctree"
srctree=$(pwd -P)
cd -- "$workdir"

if [ "$srctree" = "$workdir" ]; then
	exit 0
fi


# three
for arg ; do
	case "$arg" in
		--srctree=*)
			;;

		--)
			;;

		*)
			stat "$arg" > /dev/null 2>&1 \
				|| ln -s -- "$srctree/$arg" "$arg"
			;;
	esac
done


# all done
exit 0
