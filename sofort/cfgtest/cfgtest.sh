# cfgtest.sh: sofort's config test framework,
# for use from within a project's custom cfgdefs.sh.

# in the common scenario, host-specific tests are preceded
# by a single invocation of cfgtest_host_section, whereas
# native (build) system tests are preceded by the invocation
# of cfgtest_native_section.

# cfgdefs fraework variables:
# mb_cfgtest_cc:      the compiler used for the current test
# mb_cfgtest_cflags:  the compiler flags used for the current test
# mb_cfgtest_cfgtype: the type of the current test (host/native)
# mb_cfgtest_makevar: the make variable affected by the current test
# mb_cfgtest_headers: headers for ad-hoc inclusion with the current test


cfgtest_newline()
{
	printf '\n' >> $mb_pwd/cfgdefs.mk
}


cfgtest_comment()
{
	mb_internal_str='#'

	for mb_internal_arg ; do
		mb_internal_str="$mb_internal_str $mb_internal_arg"
	done

	printf '%s\n' "$mb_internal_str" >> $mb_pwd/cfgdefs.mk
}


cfgtest_host_section()
{
	mb_cfgtest_cc="$ccenv_host_cc"
	mb_cfgtest_cfgtype='host'
	mb_cfgtest_cflags=$(make -s -f "$mb_pwd/Makefile.tmp" .cflags-host)

	cfgtest_comment 'host-specific tests'
}


cfgtest_native_section()
{
	mb_cfgtest_cc="$mb_native_cc"
	mb_cfgtest_cfgtype='native'
	mb_cfgtest_cflags=$(make -s -f "$mb_pwd/Makefile.tmp" .cflags-native)

	cfgtest_comment 'native system tests'
}


cfgtest_prolog()
{
	cfgtest_line_dots='.......................'
	cfgtest_line_dots="${cfgtest_line_dots}${cfgtest_line_dots}"
	cfgtest_tool_desc=" == trying ${mb_cfgtest_cfgtype} ${1}: ${2}"
	cfgtest_tool_dlen="${#cfgtest_line_dots}"

	printf '\n%s\n' '________________________' >&3
	printf "cfgtest: probing for ${mb_cfgtest_cfgtype} ${1}: ${2}\n\n" >&3
	printf "%${cfgtest_tool_dlen}.${cfgtest_tool_dlen}s" \
		"${cfgtest_tool_desc}  ${mb_line_dots}"
}


cfgtest_epilog()
{
	cfgtest_line_dots='.......................'
	cfgtest_tool_dlen="$((${#cfgtest_line_dots} - ${#1}))"

	printf "%${cfgtest_tool_dlen}.${cfgtest_tool_dlen}s  %s.\n" \
		"${cfgtest_line_dots}" "${1}"

	if [ "${1}" = '-----' ]; then
		printf '\n\ncfgtest: interface is missing or cannot be used.\n' >&3
		printf '%s\n' '------------------------' >&3
		return 1
	fi
}


cfgtest_makevar_append()
{
	mb_internal_str='+='

	for mb_internal_arg ; do
		if ! [ -z "$mb_internal_arg" ]; then
			mb_internal_str="$mb_internal_str $mb_internal_arg"
		fi
	done

	printf '%-24s%s\n' "$mb_cfgtest_makevar" "$mb_internal_str" \
		>> $mb_pwd/cfgdefs.mk

	unset cfgtest_internal_unit_test
}


cfgtest_cflags_append()
{
	if [ $mb_cfgtest_cfgtype = 'host' ]; then
		mb_internal_makevar='CFLAGS_CONFIG'
	else
		mb_internal_makevar='NATIVE_CFLAGS'
	fi

	mb_cfgtest_makevar_saved=$mb_cfgtest_makevar
	mb_cfgtest_makevar=$mb_internal_makevar

	cfgtest_makevar_append "$@"
	mb_cfgtest_makevar=$mb_cfgtest_makevar_saved
}


cfgtest_ldflags_append()
{
	if [ $mb_cfgtest_cfgtype = 'host' ]; then
		mb_internal_makevar='LDFLAGS_CONFIG'
	else
		mb_internal_makevar='NATIVE_LDFLAGS'
	fi

	mb_cfgtest_makevar_saved=$mb_cfgtest_makevar
	mb_cfgtest_makevar=$mb_internal_makevar

	cfgtest_makevar_append "$@"
	mb_cfgtest_makevar=$mb_cfgtest_makevar_saved
}


cfgtest_header_presence()
{
	cfgtest_prolog 'header' "${1}"

	printf '%s -E -xc - \\\n' "$mb_cfgtest_cc"  >&3

	for cfgtest_cflag in $mb_cfgtest_cflags; do
		printf '\t%s \\\n' "$cfgtest_cflag" >&3
	done

	printf '\t%s\n\n' '--include='"${1}" >&3

	cfgtest_cmd=$(printf '%s -E -xc - %s %s'     \
		"$mb_cfgtest_cc" "$mb_cfgtest_cflags" \
		'--include='"${1}")

	$(printf '%s' "$cfgtest_cmd")   \
		< /dev/null             \
		> /dev/null 2>&3        \
	|| cfgtest_epilog '-----'       \
	|| return

	mb_internal_str=$(printf '%s%s' '-DHAVE_' "${1}"  \
			| sed -e 's/\./_/g' -e 's@/@_@g'  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	printf 'cfgtest: %s header <%s> was found and may be included.\n' \
		"$mb_cfgtest_cfgtype" "${1}" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog "${1}"
}


cfgtest_header_absence()
{
	cfgtest_prolog 'header absence' "${1}"

	printf '%s -E -xc - \\\n' "$mb_cfgtest_cc"  >&3

	for cfgtest_cflag in $mb_cfgtest_cflags; do
		printf '\t%s \\\n' "$cfgtest_cflag" >&3
	done

	printf '\t%s\n\n' '--include='"${1}" >&3

	cfgtest_cmd=$(printf '%s -E -xc - %s %s'     \
		"$mb_cfgtest_cc" "$mb_cfgtest_cflags" \
		'--include='"${1}")

	$(printf '%s' "$cfgtest_cmd")   \
		< /dev/null            \
		> /dev/null 2>&3      \
	&& cfgtest_epilog "${1}"     \
	&& return

	mb_internal_str=$(printf '%s%s' '-DHAVE_NO_' "$@" \
			| sed -e 's/\./_/g' -e 's@/@_@g'  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	printf 'cfgtest: %s header <%s> may not be included.\n' \
		"$mb_cfgtest_cfgtype" "${1}" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog '-----'
}


cfgtest_interface_presence()
{
	mb_internal_cflags=''

	for mb_header in $mb_cfgtest_headers; do
		mb_internal_cflags="$mb_internal_cflags --include=$mb_header"
	done

	printf 'void * addr = &%s;' "$@"                  \
			| $mb_cfgtest_cc -S -xc - -o -    \
			  $mb_cfgtest_cflags              \
			  $mb_internal_cflags             \
                > /dev/null 2>/dev/null                   \
	|| return 1

	mb_internal_str=$(printf '%s%s' '-DHAVE_' "$@"  \
			| sed -e 's/\./_/g'             \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	return 0
}


cfgtest_decl_presence()
{
	mb_internal_cflags=''

	for mb_header in $mb_cfgtest_headers; do
		mb_internal_cflags="$mb_internal_cflags --include=$mb_header"
	done

	printf 'void * any = (void *)%s;' "$@"            \
			| $mb_cfgtest_cc -S -xc - -o -    \
			  $mb_cfgtest_cflags              \
			  $mb_internal_cflags             \
                > /dev/null 2>/dev/null                   \
	|| return 1

	# does the argument solely consist of the macro or enum member name?
	mb_internal_str=$(printf '%s' "$@" | tr -d '[a-z][A-Z][0-9][_]')

	if [ -n "$mb_internal_str" ]; then
		return 0
	fi

	mb_internal_str=$(printf '%s%s' '-DHAVE_DECL_' "$@"  \
			| sed -e 's/\./_/g'                  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	return 0
}


cfgtest_type_size()
{
	mb_internal_cflags=''
	mb_internal_size=''
	mb_internal_test='char x[(sizeof(%s) == %s) ? 1 : -1];'

	for mb_header in $mb_cfgtest_headers; do
		mb_internal_cflags="$mb_internal_cflags --include=$mb_header"
	done

	for mb_internal_guess in 8 4 2 1 16 32 64 128; do
		if [ -z $mb_internal_size ]; then
			mb_internal_type="$@"

			mb_internal_str=$(printf "$mb_internal_test"    \
				"$mb_internal_type"                     \
				"$mb_internal_guess")

			printf '%s' "$mb_internal_str"                  \
					| $mb_cfgtest_cc -S -xc - -o -  \
					  $mb_cfgtest_cflags            \
					  $mb_internal_cflags           \
				> /dev/null 2>/dev/null                 \
			&& mb_internal_size=$mb_internal_guess
		fi
	done

	# unrecognized type, or type size not within range
	if [ -z $mb_internal_size ]; then
		return 1
	fi

	# -DSIZEOF_TYPE=SIZE
	mb_internal_str=$(printf '%s%s=%s' '-DSIZEOF_'        \
				"$mb_internal_type"           \
				"$mb_internal_size"           \
			| sed -e 's/\ /_/g' -e 's/*/P/g'      \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	return 0
}


cfgtest_code_snippet()
{
	mb_internal_cflags=''
	mb_internal_test="$@"

	for mb_header in $mb_cfgtest_headers; do
		mb_internal_cflags="$mb_internal_cflags --include=$mb_header"
	done

	printf '%s' "$mb_internal_test"                 \
			| $mb_cfgtest_cc -S -xc - -o -  \
			  $mb_cfgtest_cflags            \
			  $mb_internal_cflags           \
		> /dev/null 2>/dev/null                 \
	|| return 1

	return 0
}


cfgtest_library_presence()
{
	printf 'int main(void){return 0;}'                \
			| $mb_cfgtest_cc -o a.out -xc -   \
			  $mb_cfgtest_cflags              \
			  $@                              \
                > /dev/null 2>/dev/null                   \
	|| return 1

	rm -f a.out

	return 0
}


cfgtest_unit_header_presence()
{
	cfgtest_internal_unit_test='unit_test'
	cfgtest_header_presence "$@" || return 1
	return 0
}


cfgtest_unit_header_absence()
{
	cfgtest_internal_unit_test='unit_test'
	cfgtest_header_absence "$@" || return 1
	return 0
}


cfgtest_unit_interface_presence()
{
	cfgtest_internal_unit_test='unit_test'
	cfgtest_interface_presence "$@" || return 1
	return 0
}


cfgtest_unit_decl_presence()
{
	cfgtest_internal_unit_test='unit_test'
	cfgtest_decl_presence "$@" || return 1
	return 0
}


cfgtest_unit_type_size()
{
	cfgtest_internal_unit_test='unit_test'
	cfgtest_type_size "$@" || return 1
	return 0
}
