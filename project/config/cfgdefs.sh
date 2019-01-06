for arg ; do
	case "$arg" in
		*)
			error_msg ${arg#}: "unsupported config argument."
			exit 2
	esac
done

cfgdefs_set_arch()
{
	if [ -n "$mb_arch" ]; then
		return 0
	fi

	case "$mb_cchost" in
		*-*-*-* )
			mb_arch=${mb_cchost%-*-*-*}
			;;
		*-*-* )
			mb_arch=${mb_cchost%-*-*}
			;;
		*-* )
			mb_arch=${mb_cchost%-*-*-*}
			;;
		* )
			mb_arch='unknown'
			;;
	esac

	if [ "$mb_os" = 'midipix' ]; then
		case "$mb_arch" in
			x86_64 )
				mb_arch='nt64'
				;;
			i[3-6]86 )
				mb_arch='nt32'
				;;
		esac
	fi
}


cfgdefs_detect_libc_version()
{
	mb_libc_verinfo=$(cat "$mb_source_dir/VERSION")

	case "$mb_libc_verinfo" in
		*.*.* )
			libc_ver=${mb_libc_verinfo}
			libc_major=${mb_libc_verinfo%.*.*}
			libc_micro=${mb_libc_verinfo#*.*.}

			libc_minor=${libc_ver#*.}
			libc_minor=${libc_minor%.*}
			;;
		* )
			error_msg "Could not properly parse $mb_source_dir/VERSION"
			exit 2
	esac
}


cfgdefs_set_libc_options()
{
	if [ -d $mb_project_dir/arch/$mb_arch ]; then
		port_dir='$(PROJECT_DIR)'
		arch_dir=$mb_project_dir
	else
		port_dir='$(SOURCE_DIR)'
		arch_dir=$mb_source_dir
	fi

	if [ -f $arch_dir/arch/$mb_arch/bits/syscall.h.in ]; then
		libc_syscall_arch='syscall-gen.tag'
	else
		libc_syscall_arch='syscall-copy.tag'
	fi
}


cfgdefs_output_custom_defs()
{
	sed \
			-e 's/@port_dir@/'"$port_dir"'/g'       \
			-e 's/@libc_ver@/'"$libc_ver"'/g'       \
			-e 's/@libc_major@/'"$libc_major"'/g'   \
			-e 's/@libc_minor@/'"$libc_minor"'/g'   \
			-e 's/@libc_micro@/'"$libc_micro"'/g'   \
			-e 's/@libc_syscall_arch@/'"$libc_syscall_arch"'/g' \
		"$mb_project_dir/project/config/cfgdefs.in"         \
	| sed -e 's/[ \t]*$//g'                                     \
			>> "$mb_pwd/cfgdefs.mk"
}


# arch
cfgdefs_set_arch

# libc version info
cfgdefs_detect_libc_version

# libc (variant-specific) options
cfgdefs_set_libc_options

# cfgdefs.in --> cfgdefs.mk
cfgdefs_output_custom_defs

# all done
return 0
