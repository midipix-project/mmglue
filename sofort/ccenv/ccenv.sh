# ccenv.sh: sofort's tool-finding bits,
# invoked from within the project-agnostic configure script.

# invocation and names of binary tools:
# agnostic names (ar, nm, objdump, ...);
# target-prefixed agnostic names (x86_64-nt64-midipix-ar, ...);
# branded names (llvm-ar, llvm-nm, llvm-objdump, ...);
# target-prefixed branded names (x86_64-linux-gnu-gcc-ar, ...);
# target-specifying branded tools (llvm-ar --target=x86_64-linux, ...).

# cross-compilation: default search order:
# target-prefixed agnostic tools;
# target-prefixed branded tools, starting with the prefix
# most commonly associated with the selected compiler (that is,
# ``gcc'' when using gcc, and ``llvm'' when using clang);
# target-speficying branded tools, starting once again with the
# prefix most commonly associated with the selected compiler.

# internal variables of interest:
# ccenv_cfgtype: the type of host being tested (host/native)
# ccenv_cfgfile: the configuration file for the host being tested
# ccenv_cflags:  the comprehensive cflags for the host being tested
# ccenv_cchost:  the host being tested, as reported by -dumpmachine


ccenv_usage()
{
	cat "$mb_project_dir"/sofort/ccenv/ccenv.usage
	exit 0
}


ccenv_newline()
{
	printf '\n' >> "$ccenv_cfgfile"
}


ccenv_comment()
{
	ccenv_internal_str='#'

	for ccenv_internal_arg ; do
		ccenv_internal_str="$ccenv_internal_str $ccenv_internal_arg"
	done

	printf '%s\n' "$ccenv_internal_str" >> "$ccenv_cfgfile"
}


ccenv_find_tool()
{
	if [ -z "$ccenv_prefixes" ]; then
		for ccenv_tool in $ccenv_candidates; do
			if [ -z ${@:-} ]; then
				if command -v "$ccenv_tool" > /dev/null; then
					return 0
				fi
			else
				if command -v "$ccenv_tool" > /dev/null; then
					if "$ccenv_tool" $@ > /dev/null 2>&1; then
						return 0
					fi
				fi
			fi
		done

		ccenv_tool=false

		return 0
	fi

	for ccenv_prefix in $ccenv_prefixes; do
		for ccenv_candidate in $ccenv_candidates; do
			ccenv_tool="$ccenv_prefix$ccenv_candidate"

			if command -v "$ccenv_tool" > /dev/null; then
				return 0
			fi
		done
	done

	for ccenv_tool in $ccenv_candidates; do
		if command -v "$ccenv_tool" > /dev/null; then
			return 0
		fi
	done

	ccenv_tool=false

	return 0
}


ccenv_set_primary_tools()
{
	ccenv_core_tools="ar nm objdump ranlib size strip strings objcopy"
	ccenv_hack_tools="addr2line cov elfedit readelf readobj otool"
	ccenv_peep_tools="perk mdso dlltool windmc windres"

	for __tool in $ccenv_core_tools $ccenv_hack_tools $ccenv_peep_tools; do
		if [ -n "$mb_agnostic" ]; then
			ccenv_candidates=" $__tool"

		elif [ -n "$mb_zealous" ]; then
			ccenv_candidates="$mb_zealous-$__tool"

		elif [ "$mb_toolchain" = 'gcc' ]; then
			ccenv_candidates="gcc-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"

		elif [ "$mb_toolchain" = 'llvm' ]; then
			ccenv_candidates="llvm-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"

		elif [ -n "$mb_toolchain" ]; then
			ccenv_candidates="$mb_toolchain-$__tool"
			ccenv_candidates="$ccenv_candidates $__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"

		else
			ccenv_candidates="$__tool"
			ccenv_candidates="$ccenv_candidates gcc-$__tool"
			ccenv_candidates="$ccenv_candidates llvm-$__tool"
		fi

		if [ "$ccenv_cfgtype" = 'host' ]; then
			ccenv_var_prefix='mb_'
		else
			ccenv_var_prefix='mb_native_'
		fi

		ccenv_var_name=$ccenv_var_prefix$__tool
		ccenv_var_expr='${'$ccenv_var_name':-}'
		eval ccenv_var_val=$ccenv_var_expr

		if [ -n "$ccenv_var_val" ]; then
			eval ccenv_$__tool="$ccenv_var_val"
		else
			ccenv_find_tool
			eval ccenv_$__tool="$ccenv_tool"
		fi
	done

	# windrc
	ccenv_windrc="$ccenv_windres"
}

ccenv_set_tool_variants()
{
	# as (asm)
	ccenv_candidates=as
	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_as_asm=
	else
		$ccenv_tool --help | grep -i '.bc assembler' \
		|| ccenv_as_asm="$ccenv_tool"
	fi

	# as (ll)
	ccenv_candidates=llvm-as
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_as_ll="$ccenv_tool"
	fi

	# as (mc)
	ccenv_candidates=llvm-mc
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_as_mc="$ccenv_tool"
	fi

	# ld (bfd)
	ccenv_candidates=ld.bfd
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_bfd="$ccenv_tool"
	fi

	# ld (gold)
	ccenv_candidates=ld.gold
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_gold="$ccenv_tool"
	fi

	# ld (lld)
	ccenv_candidates=lld
	ccenv_find_tool

	if [ "$ccenv_tool" != false ]; then
		ccenv_ld_lld="$ccenv_tool"
	fi

	# objdump (bfd)
	ccenv_candidates=objdump
	ccenv_find_tool

	$ccenv_tool --version | grep -i Binutils    \
			> /dev/null                 \
		&& ccenv_objdump_bfd="$ccenv_tool"

	# objdump (llvm)
	ccenv_candidates=llvm-objdump
	ccenv_find_tool

	$ccenv_tool --version | grep -i LLVM        \
			> /dev/null                 \
		&& ccenv_objdump_llvm="$ccenv_tool"

	# readelf (bfd)
	ccenv_candidates=readelf
	ccenv_find_tool

	$ccenv_tool --version | grep -i Binutils    \
			> /dev/null                 \
		&& ccenv_readelf_bfd="$ccenv_tool"

	# readelf (llvm)
	ccenv_candidates=llvm-readelf
	ccenv_find_tool

	$ccenv_tool --version | grep -i LLVM        \
			> /dev/null                 \
		&& ccenv_readelf_llvm="$ccenv_tool"

	# as
	if [ -n "$ccenv_cc" ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'CC) -c -x assembler'
	elif [ -n "$mb_agnostic" ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ "$mb_zealous" = 'gcc' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ -n "$mb_zealous" = 'llvm' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_MC)'
	elif [ "$mb_toolchain" = 'gcc' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_ASM)'
	elif [ "$mb_toolchain" = 'llvm' ]; then
		ccenv_as='$('"$ccenv_makevar_prefix"'AS_MC)'
	fi

	# ld
	if [ -n "$ccenv_cc" ]; then
		ccenv_ld='$('"$ccenv_makevar_prefix"'CC) -nostdlib -nostartfiles'
	fi
}

ccenv_set_c_compiler_candidates()
{
	if   [ -n "$mb_compiler" ]; then
		ccenv_candidates="$mb_compiler"

	elif [ -n "$mb_agnostic" ]; then
		ccenv_candidates="c99 c11 cc"

	elif [ "$mb_zealous" = 'gcc' ]; then
		ccenv_candidates="gcc"

	elif [ "$mb_zealous" = 'llvm' ]; then
		ccenv_candidates="clang"

	elif [ "$mb_toolchain" = 'gcc' ]; then
		ccenv_candidates="gcc c99 c11 cc clang"

	elif [ "$mb_toolchain" = 'llvm' ]; then
		ccenv_candidates="clang c99 c11 cc gcc"

	elif [ -n "$mb_toolchain" ]; then
		ccenv_candidates="$mb_toolchain c99 c11 cc gcc clang"

	else
		ccenv_candidates="c99 c11 cc gcc clang"
	fi
}


ccenv_set_cc()
{
	if [ -z "$ccenv_cc" ]; then
		ccenv_set_c_compiler_candidates
		ccenv_find_tool -dumpmachine
		ccenv_cc="$ccenv_tool"
	fi

	if [ "$ccenv_cc" = false ] && [ -n "$mb_compiler" ]; then
		ccenv_cc="$mb_compiler"
	fi

	ccenv_cc_cmd="$ccenv_cc"

	if [ "$ccenv_cfgtype" = 'native' ]; then
		ccenv_host=$($ccenv_cc $ccenv_cflags -dumpmachine 2>/dev/null)
		ccenv_cchost=$ccenv_host
		return 0
	fi

	if [ -n "$mb_cchost" ]; then
		ccenv_host="$mb_cchost"
	elif [ -n "$mb_host" ]; then
		ccenv_host="$mb_host"
	else
		ccenv_host=
	fi

	if [ -z "$ccenv_host" ]; then
		ccenv_host=$($ccenv_cc $ccenv_cflags -dumpmachine 2>/dev/null)
		ccenv_cchost=$ccenv_host
	else
		ccenv_tmp=$(mktemp ./tmp_XXXXXXXXXXXXXXXX)
		ccenv_cmd="$ccenv_cc --target=$ccenv_host -E -xc -"

		if [ -z "$mb_user_cc" ]; then
			$ccenv_cmd < /dev/null > /dev/null \
				2>"$ccenv_tmp" || true

			ccenv_errors=$(cat "$ccenv_tmp")

			if [ -z "$ccenv_errors" ]; then
				ccenv_tflags="--target=$ccenv_host"
				ccenv_cc="$ccenv_cc $ccenv_tflags"
			fi
		fi

		rm -f "$ccenv_tmp"
		unset ccenv_tmp

		ccenv_cchost=$($ccenv_cc $ccenv_cflags -dumpmachine 2>/dev/null)
	fi

	if [ "$ccenv_cchost" != "$ccenv_host" ]; then
		printf 'ccenv:\n' >&2
		printf 'ccenv: ccenv_host:   %s \n' $ccenv_host >&2
		printf 'ccenv: ccenv_cchost: %s \n' $ccenv_cchost >&2

		if [ -z "$ccenv_tflags" ]; then
			printf 'ccenv:\n' >&2
			printf 'ccenv: ccenv_host and ccenv_cchost do not match, most likely because:\n' >&2
			printf 'ccenv: (1) you explicitly set CC (or passed --compiler=...)\n' >&2
			printf 'ccenv: (2) the selected compiler does not accept --target=...\n' >&2
			printf 'ccenv: (3) the host reported by -dumpmachine differs from the one you requested.\n' >&2
		fi

		if [ -n "$ccenv_errors" ]; then
			printf 'ccenv:\n' >&2
			printf 'ccenv: something went wrong, see the command and compiler message below.\n\n' >&2
			printf 'cmd: %s < /dev/null > /dev/null\n' "$ccenv_cmd" >&2
			printf '%s\n\n' "$ccenv_errors" >&2
		else
			printf 'ccenv:\n' >&2
			printf 'ccenv: something went wrong, bailing out.\n\n' >&2
		fi

		return 2
	fi
}

ccenv_set_cpp()
{
	case "$ccenv_cc_cmd" in
		cc | c99 | c11 | gcc)
			ccenv_cpp_prefix=
			ccenv_candidates="cpp" ;;

		clang )
			ccenv_cpp_prefix=
			ccenv_candidates="clang-cpp" ;;

		*-cc )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-cc*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-c99 )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-c99*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-c11 )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-c11*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-gcc )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-gcc*}-
			ccenv_candidates="${ccenv_cpp_prefix}cpp" ;;

		*-clang )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-clang*}-
			ccenv_candidates="${ccenv_cpp_prefix}clang-cpp" ;;

		* )
			ccenv_cpp="$ccenv_cc -E"
			return 0
	esac

	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_cpp="$ccenv_cc -E"
	elif [ -n "$ccenv_tflags" ]; then
		ccenv_cpp="$ccenv_tool $ccenv_tflags"
	else
		ccenv_cpp="$ccenv_tool"
	fi
}

ccenv_set_cxx()
{
	case "$ccenv_cc_cmd" in
		cc | c99 | c11 )
			ccenv_cxx_prefix=
			ccenv_candidates="cxx c++" ;;

		gcc )
			ccenv_cxx_prefix=
			ccenv_candidates="g++" ;;

		clang )
			ccenv_cxx_prefix=
			ccenv_candidates="clang++" ;;

		*-gcc )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-gcc*}-
			ccenv_candidates="${ccenv_cpp_prefix}g++" ;;

		*-clang )
			ccenv_cpp_prefix=${ccenv_cc_cmd%-clang*}-
			ccenv_candidates="${ccenv_cpp_prefix}clang++" ;;

		*cc )
			ccenv_cxx_prefix=${ccenv_cc_cmd%cc*}
			ccenv_candidates="${ccenv_cpp_prefix}++" ;;

		* )
			ccenv_cxx="$ccenv_cc -xc++"
			return 0
	esac

	ccenv_find_tool

	if [ "$ccenv_tool" = false ]; then
		ccenv_cxx="$ccenv_cc -xc++"
	elif [ -n "$ccenv_tflags" ]; then
		ccenv_cxx="$ccenv_tool $ccenv_tflags"
	else
		ccenv_cxx="$ccenv_tool"
	fi
}

ccenv_set_cc_host()
{
	ccenv_cc_host="$ccenv_cchost"
}

ccenv_set_cc_bits()
{
	ccenv_internal_size=
	ccenv_internal_type='void *'
	ccenv_internal_test='char x[(sizeof(%s) == %s/8) ? 1 : -1];'

	for ccenv_internal_guess in 64 32 128; do
		if [ -z $ccenv_internal_size ]; then
			ccenv_internal_str=$(printf "$ccenv_internal_test"  \
				"$ccenv_internal_type"                      \
				"$ccenv_internal_guess")

			printf '%s' "$ccenv_internal_str"           \
					| $ccenv_cc -S -xc - -o -   \
					  $ccenv_cflags             \
				> /dev/null 2>/dev/null             \
			&& ccenv_internal_size=$ccenv_internal_guess
		fi
	done

	ccenv_cc_bits=$ccenv_internal_size
}

ccenv_set_cc_underscore()
{
	ccenv_fn_name='ZmYaXyWbVe_UuTnSdReQrPsOcNoNrLe'
	ccenv_fn_code='int %s(void){return 0;}'

	printf "$ccenv_fn_code" $ccenv_fn_name  \
		| $ccenv_cc -xc - -S -o -       \
		| grep "^_$ccenv_fn_name:"      \
			> /dev/null             \
		&& ccenv_cc_underscore='_'

	return 0
}

ccenv_create_framework_executable()
{
	if [ -f $ccenv_image ]; then
		mv $ccenv_image $ccenv_image.tmp
		rm -f $ccenv_image.tmp
	fi

	printf 'int main(void){return 0;}'  \
		| $ccenv_cc -xc -           \
			-o $ccenv_image     \
	|| return 1

	return 0
}

ccenv_create_freestanding_executable()
{
	if [ -f $ccenv_image ]; then
		mv $ccenv_image $ccenv_image.tmp
		rm -f $ccenv_image.tmp
	fi

	if [ -z "ccenv_cc_underscore" ]; then
		ccenv_start_fn='_start'
	else
		ccenv_start_fn='start'
	fi

	printf 'int %s(void){return 0;}' "$ccenv_start_fn"  \
		| $ccenv_cc -xc -                           \
			-ffreestanding                      \
			-nostdlib -nostartfiles             \
			-o $ccenv_image                     \
	|| return 1

	ccenv_freestd=yes

	return 0
}

ccenv_set_cc_binfmt()
{
	ccenv_use_perk=
	ccenv_use_otool=
	ccenv_use_readelf=
	ccenv_use_readobj=
	ccenv_use_bfd_objdump=
	ccenv_use_llvm_objdump=

	ccenv_create_framework_executable               \
		|| ccenv_create_freestanding_executable \
		|| return 0

	# PE / perk
	if [ -n "$ccenv_perk" ]; then
		$ccenv_perk $ccenv_image 2>/dev/null \
		&& ccenv_cc_binfmt='PE'               \
		&& ccenv_use_perk=yes
	fi

	# ELF / readelf
	if [ -n "$ccenv_readelf" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_readelf -h $ccenv_image 2>/dev/null        \
			| grep 'Magic:' | sed -e 's/[ ]*//g'      \
			| grep 'Magic:7f454c46'                   \
				> /dev/null                       \
		&& ccenv_cc_binfmt='ELF'                          \
		&& ccenv_use_readelf=yes
	fi

	# a marble of astonishing design:
	# llvm-readelf also parses PE and Mach-O

	if [ -n "$ccenv_readelf_llvm" ]; then
		ccenv_readany="$ccenv_readelf_llvm"
	else
		ccenv_readany="$ccenv_readelf"
	fi

	# PE / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_readany -h $ccenv_image 2>/dev/null        \
			| grep 'Magic:' | sed -e 's/[ ]*//g'      \
			| grep 'Magic:MZ'                         \
				> /dev/null                       \
		&& ccenv_cc_binfmt='PE'                           \
		&& ccenv_use_readelf=yes
	fi

	# MACHO-64 / otool
	if [ -n "$ccenv_otool" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_otool -hv $ccenv_image 2>/dev/null         \
			| grep -i 'MH_MAGIC_64'                   \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_otool=yes
	fi

	# MACHO-32 / otool
	if [ -n "$ccenv_otool" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_otool -hv $ccenv_image 2>/dev/null         \
			| grep -i 'MH_MAGIC'                      \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_otool=yes
	fi

	# MACHO-64 / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_readany -h $ccenv_image 2>/dev/null        \
			| grep -i 'Magic:' | sed -e 's/[ ]*//g'   \
			| grep -i '(0xfeedfacf)'                  \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_readelf=yes
	fi

	# MACHO-32 / readelf
	if [ -n "$ccenv_readany" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_readany -h $ccenv_image 2>/dev/null        \
			| grep -i 'Magic:' | sed -e 's/[ ]*//g'   \
			| grep -i '(0xcafebabe)'                  \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_readelf=yes
	fi

	# MACHO / readobj
	if [ -n "$ccenv_readobj" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_readobj $ccenv_image 2>/dev/null           \
			| grep -i 'Format:' | sed 's/ /_/g'       \
			| grep -i '_Mach-O_'                      \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_readobj=yes
	fi

	# MACHO / objdump (llvm)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_objdump -section-headers $ccenv_image      \
				2>/dev/null                       \
			| grep -i 'file format Mach-O'            \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_objdump=yes
	fi

	# MACHO / objdump (bfd)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_objdump -h  $ccenv_image 2>/dev/null       \
			| grep -i 'file format Mach-O'            \
				> /dev/null                       \
		&& ccenv_cc_binfmt='MACHO'                        \
		&& ccenv_use_objdump=yes
	fi

	# PE / objdump (bfd)
	if [ -n "$ccenv_objdump" ] && [ -z "$ccenv_cc_binfmt" ]; then
		$ccenv_objdump -h  $ccenv_image 2>/dev/null       \
			| grep -i 'file format pei-'              \
				> /dev/null                       \
		&& ccenv_cc_binfmt='PE'                           \
		&& ccenv_use_bfd_objdump=yes
	fi
}

ccenv_set_os_pe()
{
	if [ -n "$ccenv_freestd" ]; then
		case "$ccenv_cchost" in
			*-midipix | *-midipix-* )
				ccenv_os='midipix' ;;
			*-mingw | *-mingw32 | *-mingw64 )
				ccenv_os='mingw' ;;
			*-mingw-* | *-mingw32-* | *-mingw64 )
				ccenv_os='mingw' ;;
			*-msys | *-msys2 | *-msys-* | *-msys2-* )
				ccenv_os='msys' ;;
			*-cygwin | *-cygwin-* )
				ccenv_os='cygwin' ;;
		esac
	fi

	if [ -n "$ccenv_os" ]; then
		return 0
	fi

	if [ -n "$ccenv_use_perk" ]; then
		ccenv_framework=$($ccenv_perk -y $ccenv_image)
		ccenv_os=${ccenv_framework#*-*-*-*}
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image | grep -i 'DLL Name' \
			| grep 'cygwin1.dll' > /dev/null                \
		&& ccenv_os='cygwin'
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image | grep -i 'DLL Name' \
			| grep 'msys-2.0.dll' > /dev/null               \
		&& ccenv_os='msys'
	fi

	if [ -z "$ccenv_os" ] && [ -n "$ccenv_objdump_bfd" ]; then
		$ccenv_objdump_bfd -x $ccenv_image          \
			| grep -i 'DLL Name' | grep '.CRT'  \
				> /dev/null                 \
		&& $ccenv_objdump_bfd -x $ccenv_image       \
			| grep -i 'DLL Name' | grep '.bss'  \
				> /dev/null                 \
		&& $ccenv_objdump_bfd -x $ccenv_image       \
			| grep -i 'DLL Name' | grep '.tls'  \
				> /dev/null                 \
		&& ccenv_os='mingw'
	fi
}

ccenv_set_os_macho()
{
	case "$ccenv_cchost" in
		*-apple-darwin* )
			ccenv_os='darwin' ;;
	esac
}

ccenv_set_os()
{
	case "$ccenv_cc_binfmt" in
		PE )
			ccenv_set_os_pe ;;
		MACHO )
			ccenv_set_os_macho ;;
	esac

	if [ -n "$ccenv_os" ]; then
		return 0
	fi

	case "$ccenv_cchost" in
		*-*-*-* )
			ccenv_tip=${ccenv_cchost%-*}
			ccenv_os=${ccenv_tip#*-*-}
			;;
		*-*-musl | *-*-gnu )
			ccenv_tip=${ccenv_cchost%-*}
			ccenv_os=${ccenv_tip#*-}
			;;
		*-*-* )
			ccenv_os=${ccenv_cchost#*-*-}
			;;
		*-* )
			ccenv_os=${ccenv_cchost#*-}
			;;
	esac

	if [ -z "$ccenv_os" ]; then
		ccenv_os='anyos'
	fi
}

ccenv_set_os_flags()
{
	case "$ccenv_os" in
		darwin )
			ccenv_cflags_os='-D_DARWIN_C_SOURCE'
			ccenv_cflags_pic='-fPIC'
			;;
		midipix )
			ccenv_cflags_os=
			ccenv_cflags_pic='-fPIC'
			;;
		cygwin )
			ccenv_cflags_os=
			ccenv_cflags_pic=
			;;
		msys | msys* | mingw | mingw* )
			ccenv_cflags_os='-U__STRICT_ANSI__'
			ccenv_cflags_pic=
			;;
		* )
			ccenv_cflags_os=
			ccenv_cflags_pic='-fPIC'
			;;
	esac
}

ccenv_set_os_semantics()
{
	# binary_format - core_api - ex_api - dependency_resolution

	case "$ccenv_os" in
		linux )
			ccenv_os_semantics='elf-posix-linux-ldso'
			;;
		bsd )
			ccenv_os_semantics='elf-posix-bsd-ldso'
			;;
		darwin )
			ccenv_os_semantics='macho-posix-osx-ldso'
			;;
		midipix )
			ccenv_os_semantics='pe-posix-winnt-ldso'
			;;
		cygwin )
			ccenv_os_semantics='pe-hybrid-winnt-unsafe'
			;;
		msys )
			ccenv_os_semantics='pe-hybrid-winnt-unsafe'
			;;
		mingw )
			ccenv_os_semantics='pe-win32-winnt-unsafe'
			;;
	esac

	if [ -n "$ccenv_os_semantics" ]; then
		return 0
	fi

	if [ -n "$ccenv_cc_binfmt" ]; then
		ccenv_os_semantics_pattern='%s-posix-anyos-unknown'
		ccenv_os_semantics=$(printf                   \
				"$ccenv_os_semantics_pattern"  \
				"$ccenv_cc_binfmt"              \
			| tr '[:upper:]' '[:lower:]')
	else
		ccenv_os_semantics='unknown-posix-anyos-unknown'
	fi
}

ccenv_set_os_dso_exrules()
{
	case "$ccenv_os" in
		midipix )
			ccenv_os_dso_exrules='pe-mdso'
			;;
		* )
			if [ "$ccenv_cc_binfmt" = 'PE' ]; then
				ccenv_os_dso_exrules='pe-dlltool'
			else
				ccenv_os_dso_exrules='default'
			fi
	esac
}

ccenv_set_os_dso_linkage()
{
	# todo: PIC, PIE, and friends
	ccenv_os_dso_linkage='default'
}

ccenv_set_os_dso_patterns_darwin()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.dylib

	ccenv_os_implib_ext=.invalid
	ccenv_os_libdef_ext=.invalid

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix=
	ccenv_os_lib_suffixed_suffix='$(OS_LIB_SUFFIX)'
}

ccenv_set_os_dso_patterns_mdso()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.so

	ccenv_os_implib_ext=.lib.a
	ccenv_os_libdef_ext=.so.def

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns_dlltool()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=.exe

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.dll

	ccenv_os_implib_ext=.dll.a
	ccenv_os_libdef_ext=.def

	ccenv_os_archive_ext=.a
	ccenv_os_soname=copy

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns_default()
{
	ccenv_os_app_prefix=
	ccenv_os_app_suffix=

	ccenv_os_lib_prefix=lib
	ccenv_os_lib_suffix=.so

	ccenv_os_implib_ext=.invalid
	ccenv_os_libdef_ext=.invalid

	ccenv_os_archive_ext=.a
	ccenv_os_soname=symlink

	ccenv_os_lib_prefixed_suffix='$(OS_LIB_SUFFIX)'
	ccenv_os_lib_suffixed_suffix=
}

ccenv_set_os_dso_patterns()
{
	# sover: .so.x.y.z
	# verso: .x.y.z.so

	case "$ccenv_os" in
		darwin )
			ccenv_set_os_dso_patterns_darwin
			;;
		midipix )
			ccenv_set_os_dso_patterns_mdso
			;;
		cygwin | msys | mingw )
			ccenv_set_os_dso_patterns_dlltool
			;;
		* )
			ccenv_set_os_dso_patterns_default
			;;
	esac
}

ccenv_set_os_pe_switches()
{
	if [ "$ccenv_cc_binfmt" = 'PE' ] && [ -z "$ccenv_pe_subsystem" ]; then
		case "$ccenv_os" in
			midipix | mingw )
				ccenv_pe_subsystem='windows'
				;;
			* )
				ccenv_pe_subsystem='console'
				;;
		esac
	fi
}

ccenv_output_defs()
{
	ccenv_in="$mb_project_dir/sofort/ccenv/ccenv.in"
	ccenv_mk="$mb_pwd/ccenv/$ccenv_cfgtype.mk"

	if [ "$ccenv_cc_binfmt" = 'PE' ]; then
		ccenv_pe="$mb_project_dir/sofort/ccenv/pedefs.in"
		ccenv_in="$ccenv_in $ccenv_pe"
	fi

	if [ $ccenv_cfgtype = 'native' ]; then

		ccenv_tmp=$(mktemp ./tmp_XXXXXXXXXXXXXXXX)

		sed                             \
				-e 's/^\s*$/@/g' \
				-e 's/^/NATIVE_/' \
				-e 's/NATIVE_@//g' \
				-e 's/NATIVE_#/#/g' \
				-e 's/       =/=/g'  \
				-e 's/       +=/+=/g' \
			$ccenv_in > "$ccenv_tmp"

		ccenv_in="$ccenv_tmp"
	else
		unset ccenv_tmp
	fi

	ccenv_vars=$(cut -d'=' -f1 "$mb_project_dir/sofort/ccenv/ccenv.vars" \
			| grep -v '^#')

	ccenv_exvars="ccenv_cfgtype ccenv_makevar_prefix"

	ccenv_sed_substs=" \
		$(for __var in $ccenv_vars $ccenv_exvars; do \
			printf '%s"$%s"%s' "-e 's/@$__var@/'" \
				"$__var" "'/g' ";              \
		done)"

	eval sed $ccenv_sed_substs $ccenv_in   \
			| sed -e 's/[[:blank:]]*$//g' \
		> "$ccenv_mk"

	if [ "$ccenv_cfgtype" = 'host' ]; then
		for __var in $ccenv_vars; do
			ccenv_src_var=$__var
			ccenv_dst_var=mb_${__var#*ccenv_}
			ccenv_var_expr='${'$ccenv_src_var':-}'
			eval $ccenv_dst_var=$ccenv_var_expr

		done

		mb_host=$ccenv_host
		mb_cchost=$ccenv_cchost
	else
		for __var in $ccenv_vars; do
			ccenv_src_var=$__var
			ccenv_dst_var=mb_native_${__var#*ccenv_}
			ccenv_var_expr='${'$ccenv_src_var':-}'
			eval "$ccenv_dst_var=$ccenv_var_expr"
		done

		mb_native_host=$ccenv_host
		mb_native_cchost=$ccenv_cchost
	fi

	if [ -n "${ccenv_tmp:-}" ]; then
		rm -f "$ccenv_tmp"
		unset ccenv_tmp
	fi
}

ccenv_dso_verify()
{
	ccenv_str='int foo(int x){return ++x;}'
	ccenv_cmd="$ccenv_cc -xc - -shared -o a.out"

	rm -f a.out

	printf '%s' "$ccenv_str" | $ccenv_cmd \
		> /dev/null 2>/dev/null       \
	|| mb_disable_shared=yes

	rm -f a.out
}

ccenv_clean_up()
{
	rm -f $ccenv_image
}

ccenv_common_init()
{
	. "$mb_project_dir/sofort/ccenv/ccenv.vars"

	ccenv_cfgtype=$1
	ccenv_cfgfile="$mb_pwd/ccenv/$ccenv_cfgtype.mk"
	ccenv_freestd=
	ccenv_cchost=

	if [ $ccenv_cfgtype = 'native' ]; then
		ccenv_makevar_prefix='NATIVE_'
		ccenv_image='./ccenv/native.a.out'
	else
		ccenv_makevar_prefix=
		ccenv_image='./ccenv/host.a.out'
	fi

	if [ $ccenv_cfgtype = 'native' ]; then
		ccenv_prefixes=
	elif [ -n "$mb_cross_compile" ]; then
		ccenv_prefixes="$mb_cross_compile"
	elif [ -n "$mb_host" ]; then
		ccenv_prefixes="$mb_host-"
	else
		ccenv_prefixes=
	fi

	if [ $ccenv_cfgtype = 'host' ]; then
		ccenv_tflags=
		ccenv_cflags=$(make -s -f "$mb_pwd/Makefile.tmp" .display-cflags)
		ccenv_cc="$mb_user_cc"
		ccenv_cpp="$mb_user_cpp"
		ccenv_cxx="$mb_user_cxx"

		ccenv_pe_subsystem="$mb_pe_subsystem"
		ccenv_pe_image_base="$mb_pe_image_base"
	else
		ccenv_tflags=
		ccenv_cflags="$mb_native_cflags"
		ccenv_cc="$mb_native_cc"
		ccenv_cpp="$mb_native_cpp"
		ccenv_cxx="$mb_native_cxx"

		ccenv_pe_subsystem="$mb_native_pe_subsystem"
		ccenv_pe_image_base="$mb_native_pe_image_base"
	fi
}

ccenv_set_characteristics()
{
	ccenv_set_cc_host
	ccenv_set_cc_bits
	ccenv_set_cc_underscore
	ccenv_set_cc_binfmt
}

ccenv_set_toolchain_variables()
{
	ccenv_common_init $1
	ccenv_set_cc
	ccenv_set_cpp
	ccenv_set_cxx
	ccenv_set_primary_tools
	ccenv_set_tool_variants
	ccenv_set_characteristics

	ccenv_set_os
	ccenv_set_os_flags
	ccenv_set_os_semantics
	ccenv_set_os_dso_exrules
	ccenv_set_os_dso_linkage
	ccenv_set_os_dso_patterns
	ccenv_set_os_pe_switches

	ccenv_output_defs
	ccenv_clean_up
}

ccenv_set_host_variables()
{
	ccenv_set_toolchain_variables 'host'
	ccenv_dso_verify
}

ccenv_set_native_variables()
{
	if [ _$mb_ccenv_skip_native != _yes ]; then
		ccenv_set_toolchain_variables 'native'
	fi
}
