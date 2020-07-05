for arg ; do
	case "$arg" in
		--no-complex )
			libc_no_complex=yes
			;;
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

	if [ -f $mb_source_dir/arch/x86_64/atomic_arch.h ]; then
		libc_source_tree='-D__LIBC_MODERN_SOURCE_TREE'
	else
		libc_source_tree='-D__LIBC_LEGACY_SOURCE_TREE'
	fi

	if [ -f $arch_dir/arch/$mb_arch/bits/alltypes.sed ]; then
		alltypes_sed=$arch_dir/arch/$mb_arch/bits/alltypes.sed
	else
		alltypes_sed=build/alltypes.sed
	fi

	if [ _${libc_no_complex:-} = _yes ]; then
		libc_deps=
		libc_excl_files='$(filter ./src/complex/%, $(libc_all_files))'
	else
		libc_deps='-lgcc -lgcc_eh'
		libc_excl_files=
	fi
}


cfgdefs_set_libc_cflags()
{
	libc_td_tid_addr=
	mb_init_tls_src_file=$mb_source_dir/src/env/__init_tls.c

	[ -z $libc_td_tid_addr ] \
		&& grep '__syscall(SYS_set_tid_address, &td->tid)' $mb_init_tls_src_file > /dev/null \
			&& libc_td_tid_addr='-D__LIBC_TD_TID_ADDR_TID'

	[ -z $libc_td_tid_addr ] \
		&& grep '__syscall(SYS_set_tid_address, &td->join_futex)' $mb_init_tls_src_file > /dev/null \
			&& libc_td_tid_addr='-D__LIBC_TD_TID_ADDR_JOIN_FUTEX'

	[ -z $libc_td_tid_addr ] \
		&& grep '__syscall(SYS_set_tid_address, &td->detach_state)' $mb_init_tls_src_file > /dev/null \
			&& libc_td_tid_addr='-D__LIBC_TD_TID_ADDR_DETACH_STATE'

	[ -z $libc_td_tid_addr ] \
		&& grep '__syscall(SYS_set_tid_address, &__thread_list_lock)' $mb_init_tls_src_file > /dev/null \
			&& libc_td_tid_addr='-D__LIBC_TD_TID_ADDR_THREAD_LIST_LOCK'

	return 0
}


cfgdefs_set_malloc_options()
{
	if [ -d $mb_source_dir/src/malloc/mallocng ]; then
		malloc_subdir='src/malloc/mallocng'
	else
		malloc_subdir='src/malloc/oldmalloc'
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
			-e 's/@libc_deps@/'"$libc_deps"'/g'     \
			-e 's^@libc_excl_files@^'"$libc_excl_files"'^g'   \
			-e 's/@libc_source_tree@/'"$libc_source_tree"'/g'  \
			-e 's/@libc_syscall_arch@/'"$libc_syscall_arch"'/g' \
			-e 's/@libc_td_tid_addr@/'"$libc_td_tid_addr"'/g'    \
			-e 's!@alltypes_sed@!'"$alltypes_sed"'!g'             \
			-e 's!@malloc_subdir@!'"$malloc_subdir"'!g'            \
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

# libc (variant-specific) cflags
cfgdefs_set_libc_cflags

# malloc implementation variant
cfgdefs_set_malloc_options

# cfgdefs.in --> cfgdefs.mk
cfgdefs_output_custom_defs

# all done
return 0
