# cfgtest.sh: sofort's config test framework,
# for use from within a project's custom cfgdefs.sh.

# this file is covered by COPYING.SOFORT.

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
	mb_cfgtest_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .cflags-host)
	mb_cfgtest_cflags="${mb_cfgtest_cflags#*: }"

	mb_cfgtest_ldflags="$mb_ldflags_cmdline"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_debug"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_common"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_strict"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_config"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_sysroot"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_path"
	mb_cfgtest_ldflags="$mb_cfgtest_ldflags $mb_ldflags_last"

	cfgtest_comment 'host-specific tests'
}


cfgtest_native_section()
{
	mb_cfgtest_cc="$mb_native_cc"
	mb_cfgtest_cfgtype='native'
	mb_cfgtest_cflags=$(${mb_make} -n -f "$mb_pwd/Makefile.tmp" .cflags-native)
	mb_cfgtest_cflags="${mb_cfgtest_cflags#*: }"
	mb_cfgtest_ldflags="$mb_native_ldflags"

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
	cfgtest_tool_dlen="$((${#cfgtest_line_dots} - ${#2}))"

	printf "%${cfgtest_tool_dlen}.${cfgtest_tool_dlen}s  %s.\n" \
		"${cfgtest_line_dots}" "${2}"

	if [ "${1}" = 'snippet' ] && [ -f = 'a.out' ]; then
		rm -f 'a.out'
	fi

	if [ "${1}" = 'snippet' ] && [ "${2}" = '(error)' ]; then
		printf '\n\ncfgtest: the %s compiler %s %s.\n' \
			"$mb_cfgtest_cfgtype"                 \
			'failed to compile the above code'   \
			"${1}" >&3
		printf '%s\n' '------------------------' >&3
		return 1
	fi

	if [ "${2}" = '-----' ]; then
		printf '\n\ncfgtest: %s %s is missing or cannot be found.\n' "${1}" "${3}" >&3
		printf '%s\n' '------------------------' >&3
		return 1
	elif [ "${1}" = 'size-of-type' ] && [ "${2}" = '(error)' ]; then
		printf '\n\ncfgtest: could not determine size of type `%s.\n' "${3}'" >&3
		printf '%s\n' '------------------------' >&3
		return 1
	elif [ "${2}" = '(error)' ]; then
		printf '\n\ncfgtest: %s `%s is not defined or cannot be used.\n' "${1}" "${3}'" >&3
		printf '%s\n' '------------------------' >&3
		return 1
	fi
}


cfgtest_entity_size_prolog()
{
	cfgtest_line_dots='.......................'
	cfgtest_line_dots="${cfgtest_line_dots}${cfgtest_line_dots}"
	cfgtest_tool_desc=" == checking size of ${mb_cfgtest_cfgtype} type: ${@}"
	cfgtest_tool_dlen="${#cfgtest_line_dots}"

	printf '\n%s\n' '________________________' >&3
	printf "cfgtest: checking size of ${mb_cfgtest_cfgtype} type: ${@}\n\n" >&3

	printf "%${cfgtest_tool_dlen}.${cfgtest_tool_dlen}s" \
		"${cfgtest_tool_desc}  ${mb_line_dots}"
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


cfgtest_common_init()
{
	# cfgtest variables
	cfgtest_type="${1:-}"

	if [ "$cfgtest_type" = 'asm' ]; then
		cfgtest_fmt='%s -c -xc - -o a.out'
	elif [ "$cfgtest_type" = 'lib' ]; then
		cfgtest_fmt='%s -xc - -o a.out'
	else
		cfgtest_fmt='%s -S -xc - -o -'
	fi

	if [ "$cfgtest_type" = 'lib' ]; then
		cfgtest_cmd=$(printf "$cfgtest_fmt %s %s %s" \
			"$mb_cfgtest_cc"                     \
			"$mb_cfgtest_cflags"                 \
			"$mb_cfgtest_ldflags"                \
			"$cfgtest_libs")
	else
		cfgtest_cmd=$(printf "$cfgtest_fmt %s" \
			"$mb_cfgtest_cc"               \
			"$mb_cfgtest_cflags")
	fi

	if [ -z "$mb_cfgtest_headers" ] || [ "$cfgtest_type" = 'lib' ]; then
		cfgtest_inc=
		cfgtest_src="$cfgtest_code_snippet"
	else
		cfgtest_inc=$(printf '#include <%s>\n' $mb_cfgtest_headers)
		cfgtest_src=$(printf '%s\n_\n' "$cfgtest_inc" \
			| m4 -D_="$cfgtest_code_snippet")
	fi

	# config.log
	printf "$cfgtest_fmt" "$mb_cfgtest_cc" >&3

	for cfgtest_cflag in $mb_cfgtest_cflags; do
		printf ' \\\n\t%s' "$cfgtest_cflag" >&3
	done

	if [ "$cfgtest_type" = 'lib' ]; then
		for cfgtest_lib in $cfgtest_libs; do
			printf ' \\\n\t%s' "$cfgtest_lib" >&3
		done
	fi

	printf ' \\\n'                           >&3
	printf '<< _SRCEOF\n%s\n' "$cfgtest_src" >&3
	printf '_SRCEOF \n\n\n'                  >&3
}


cfgtest_header_presence()
{
	#init
	cfgtest_prolog 'header' "${1}"

	cfgtest_code_snippet=$(printf '#include <%s>\n' "${1}")

	cfgtest_common_init

	# execute
	printf '%s' "$cfgtest_src"                  \
		| eval $(printf '%s' "$cfgtest_cmd") \
		> /dev/null 2>&3                      \
	|| cfgtest_epilog 'header' '-----' "<${1}>"    \
	|| return

	# result
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

	cfgtest_epilog 'header' "${1}"
}


cfgtest_header_absence()
{
	#init
	cfgtest_prolog 'header absence' "${1}"

	cfgtest_code_snippet=$(printf '#include <%s>\n' "${1}")

	cfgtest_common_init

	# execute
	printf '%s' "$cfgtest_src"                  \
		| eval $(printf '%s' "$cfgtest_cmd") \
		> /dev/null 2>&3                      \
	&& printf 'cfgtest: %s header <%s>: no error.' \
		"$mb_cfgtest_cfgtype" "${1}" >&3        \
	&& cfgtest_epilog 'header' "${1}"                \
	&& return

	# result
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

	cfgtest_epilog 'header' '-----'
}


cfgtest_interface_presence()
{
	# init
	cfgtest_prolog 'interface' "${1}"

	cfgtest_code_snippet=$(printf 'void * addr = &%s;\n' "${1}")

	cfgtest_common_init

	# execute
	printf '%s' "$cfgtest_src"                    \
		| eval $(printf '%s' "$cfgtest_cmd")   \
		> /dev/null 2>&3                        \
	|| cfgtest_epilog 'interface' '(error)' "${1}"   \
	|| return

	# result
	mb_internal_str=$(printf '%s%s' '-DHAVE_' "$@"  \
			| sed -e 's/\./_/g'             \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	printf 'cfgtest: %s interface `%s'"'"' is available.\n' \
		"$mb_cfgtest_cfgtype" "${1}" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog 'interface' "${1}"

	return 0
}


cfgtest_decl_presence()
{
	# init
	cfgtest_prolog 'decl' "${1}"

	cfgtest_code_snippet=$(printf 'void * any = (void *)(%s);' "${1}")

	cfgtest_common_init

	# execute
	printf '%s' "$cfgtest_src"                  \
		| eval $(printf '%s' "$cfgtest_cmd") \
		> /dev/null 2>&3                      \
	|| cfgtest_epilog 'decl' '(error)' "${1}"      \
	|| return

	# does the argument solely consist of the macro or enum member name?
	mb_internal_str=$(printf '%s' "$@" | tr -d '[a-z][A-Z][0-9][_]')

	if [ -n "$mb_internal_str" ]; then
		cfgtest_epilog 'decl' '(defined)'
		return 0
	fi

	# result
	mb_internal_str=$(printf '%s%s' '-DHAVE_DECL_' "$@"  \
			| sed -e 's/\./_/g'                  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi

	printf 'cfgtest: `%s'"'"' is defined for the %s system.\n' \
		"${1}" "$mb_cfgtest_cfgtype" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog 'decl' '(defined)'

	return 0
}


cfgtest_type_size()
{
	cfgtest_entity_size_prolog "$@"

	mb_internal_size=''
	mb_internal_test='char x[(sizeof(%s) == %s) ? 1 : -1];'

	for mb_internal_guess in 8 4 2 1 16 32 64 128; do
		if [ -z $mb_internal_size ]; then
			printf '# guess %s ===>\n' "$mb_internal_guess" >&3

			mb_internal_type="$@"

			cfgtest_code_snippet=$(printf "$mb_internal_test" \
				"$mb_internal_type" "$mb_internal_guess")

			cfgtest_common_init

			printf '%s' "$cfgtest_src"                  \
				| eval $(printf '%s' "$cfgtest_cmd") \
				> /dev/null 2>&3                      \
			&& mb_internal_size=$mb_internal_guess

			printf '\n' >&3
		fi
	done

	# unrecognized type, or type size not within range
	if [ -z $mb_internal_size ]; then
		cfgtest_epilog 'size-of-type' '(error)' "@"
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

	printf 'cfgtest: size of type `%s'"'"' determined to be %s\n' \
		"${@}" "$mb_internal_size" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog 'size-of-type' "$mb_internal_size"

	return 0
}


cfgtest_code_snippet_asm()
{
	# init
	cfgtest_prolog 'support of code snippet' '<...>'

	cfgtest_code_snippet="$@"

	cfgtest_common_init 'asm'

	# execute
	cfgtest_ret=1

	printf '%s' "$cfgtest_src"                  \
		| eval $(printf '%s' "$cfgtest_cmd") \
		> /dev/null 2>&3                      \
	|| cfgtest_epilog 'snippet' '(error)'          \
	|| return

	# result
	cfgtest_ret=0

	printf 'cfgtest: %s compiler: above code snippet compiled successfully.\n\n' \
		"$mb_cfgtest_cfgtype" >&3

	cfgtest_epilog 'snippet' '(ok)'

	return 0
}


cfgtest_library_presence()
{
	# init
	cfgtest_libs=
	cfgtest_spc=

	for cfgtest_lib in ${@}; do
		cfgtest_libs="$cfgtest_libs$cfgtest_spc$cfgtest_lib"
		cfgtest_spc=' '
	done

	if [ "${1}" = "$cfgtest_libs" ]; then
		cfgtest_prolog 'library' "${1#*-l}"
	else
		cfgtest_prolog 'lib module' '(see config.log)'
	fi

	cfgtest_code_snippet='int main(void){return 0;}'

	cfgtest_common_init 'lib'

	# execute
	printf '%s' "$cfgtest_src"                  \
		| eval $(printf '%s' "$cfgtest_cmd") \
		> /dev/null 2>&3                      \
	|| cfgtest_epilog 'library' '-----' "$@"       \
	|| return 1

	# result
	printf 'cfgtest: `%s'"'"' was accepted by the linker driver.\n' \
		"$cfgtest_libs" >&3
	printf '%s\n' '------------------------' >&3

	cfgtest_epilog 'library' '(present)'

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
