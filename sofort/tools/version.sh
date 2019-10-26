#!/bin/sh

set -eu

usage()
{
cat << EOF >&2

Usage:
  -h            show this HELP message
  -s  SRCDIR    set source directory
  -o  OUTPUT    set output header
  -p  PREFIX    set macro prefix

EOF
exit 1
}


# one
workdir=$(pwd -P)
srcdir=
output=
prefix=


while getopts "hs:o:p:" opt; do
	case $opt in
	h)
  		usage
  		;;
	s)
    		srcdir="$OPTARG"
    		;;
	o)
    		output="$OPTARG"
    		;;
	p)
    		prefix="$OPTARG"
    		;;
	\?)
		printf 'Invalid option: -%s' "$OPTARG" >&2
    		usage
    		;;
	esac
done


# two
if [ -z "$srcdir" ] || [ -z "$output" ] || [ -z "$prefix" ]; then
	usage
fi

cd -- "$srcdir"

gitver=$(git rev-parse --verify HEAD      2>/dev/null) || gitver="unknown"
cvdate=$(git show -s --format=%ci $gitver 2>/dev/null) || cvdate=$(date)

vmacro=$(printf '%s' "$prefix"'_GIT_VERSION' | tr '[:lower:]' '[:upper:]')
dmacro=$(printf '%s' "$prefix"'_GIT_DATE   ' | tr '[:lower:]' '[:upper:]')

cd -- "$workdir"


# three
printf '#define %s "%s"\n#define %s "%s"\n' \
		"$vmacro" "$gitver" \
		"$dmacro" "$cvdate" \
	> "$output"

# all done
exit 0
