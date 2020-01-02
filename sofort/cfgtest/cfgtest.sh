# cfgtest.sh: sofort's config test framework,
# for use from within a project's custom cfgdefs.sh.

# in the common scenario, target-specific tests are preceded
# by a single invocation of cfgtest_target_section, whereas
# native (build) system tests are preceded by the invocation
# of cfgtest_native_section.

# cfgdefs fraework variables:
# mb_cfgtest_cc:      the compiler used for the current test
# mb_cfgtest_cflags:  the compiler flags used for the current test
# mb_cfgtest_cfgtype: the type of the current test (target/native)
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


cfgtest_target_section()
{
	mb_cfgtest_cflags=
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_debug   $mb_cflags_config"
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_sysroot $mb_cflags_common"
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_cmdline $mb_cflags"
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_path    $mb_cflags_os"
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_site    $mb_cflags_strict"
	mb_cfgtest_cflags="$mb_cfgtest_cflags $mb_cflags_last    $mb_cflags_once"

	mb_cfgtest_cc="$ccenv_host_cc"
	mb_cfgtest_cfgtype='target'

	cfgtest_comment 'target-specific tests'
}


cfgtest_native_section()
{
	mb_cfgtest_cc="$mb_native_cc"
	mb_cfgtest_cflags="$mb_native_cflags"
	mb_cfgtest_cfgtype='native'

	cfgtest_comment 'native system tests'
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
	if [ $mb_cfgtest_cfgtype = 'target' ]; then
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
	if [ $mb_cfgtest_cfgtype = 'target' ]; then
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
	$mb_cfgtest_cc -E -xc -             \
			$mb_cfgtest_cflags  \
			--include="$@"      \
		< /dev/null                 \
		> /dev/null 2>/dev/null     \
	|| return

	mb_internal_str=$(printf '%s%s' '-DHAVE_' "$@"    \
			| sed -e 's/\./_/g' -e 's@/@_@g'  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi
}


cfgtest_header_absence()
{
	$mb_cfgtest_cc -E -xc -             \
			$mb_cfgtest_cflags  \
			--include="$@"      \
		< /dev/null                 \
		> /dev/null 2>/dev/null     \
	&& return

	mb_internal_str=$(printf '%s%s' '-DHAVE_NO_' "$@" \
			| sed -e 's/\./_/g' -e 's@/@_@g'  \
			| tr "[:lower:]" "[:upper:]")

	if [ -z ${cfgtest_internal_unit_test:-} ]; then
		cfgtest_cflags_append "$mb_internal_str"
	else
		cfgtest_makevar_append "$mb_internal_str"
	fi
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
