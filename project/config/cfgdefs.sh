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

# arch
cfgdefs_set_arch

# all done
return 0
