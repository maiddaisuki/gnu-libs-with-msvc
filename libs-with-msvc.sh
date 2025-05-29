#!/bin/env sh

# Build GNU Libraries with MSVC tools

export LC_ALL=C

tab='	'
nl='
'

IFS=" ${tab}${nl}"

if [ ${BASH_VERSION+y} ]; then
	shopt -so posix
fi

self=$(realpath "$0")
selfdir=$(dirname "${self}")

self_log=/dev/null

print() {
	printf "%s\n" "$*" | tee -a "${self_log}"
}

note() {
	printf "NOTE: %s\n" "$*" | tee -a "${self_log}"
}

warning() {
	printf "WARNING: %s\n" "$*" | tee -a "${self_log}" >&2
}

error() {
	printf "ERROR: %s\n" "$*" | tee -a "${self_log}" >&2
}

die() {
	error "$*"
	exit 1
}

##
# Parse options
#

opt_env=${selfdir}/vs.sh
opt_host=x86_64-w64-mingw32

opt_toolchain=msvc

opt_buildtype=release
opt_debug=false
opt_legacy=false
opt_static=false

opt_enable_stage1=true
opt_enable_stage2=true

opt_ncurses_workaround=false
opt_ncurses_static=false

while [ $# -gt 0 ]; do
	opt=$1 && shift

	case ${opt} in
	--buildtype=*)
		opt_buildtype=${opt#--buildtype=}
		;;
	--buildtype)
		opt_buildtype=$1
		shift || die "${opt}: missing argument"
		;;
	--debug)
		opt_debug=true
		;;
	--disable-stage1)
		opt_enable_stage1=false
		;;
	--disable-stage2)
		opt_enable_stage2=false
		;;
	--env=*)
		opt_env=${opt#--env=}
		;;
	--env)
		opt_env=$1
		shift || die "${opt}: missing argument"
		;;
	--host)
		opt_host=$1
		shift || die "${opt}: missing argument"
		;;
	--host=*)
		opt_host=${opt#--host=}
		;;
	--legacy)
		opt_legacy=true
		;;
	--llvm)
		opt_toolchain=llvm
		;;
	--ncurses-workaround)
		opt_ncurses_workaround=true
		;;
	--ncurses-static)
		opt_ncurses_static=true
		;;
	--static)
		opt_static=true
		;;
	*)
		die "${opt}: unrecognized option"
		;;
	esac
done

##
# Make sure required tools are in PATH
#

if [ -f "${opt_env}" ]; then
	. ${opt_env}
else
	error "${opt_env}: file does not exist"
	die "use --env option to specify script to read"
fi

if ! type cl.exe >/dev/null 2>&1; then
	die "cl.exe is not found in PATH"
fi

##
# Read configs
#

dir_include=${selfdir}/include
dir_packages=${selfdir}/packages

# User configs
. ${selfdir}/config/dirs.sh
. ${selfdir}/config/flags.sh
. ${selfdir}/config/options.sh
. ${selfdir}/config/packages.sh
# Internal configs
. ${dir_include}/verify.sh
. ${dir_include}/dirs.sh
. ${dir_include}/options.sh
# Functions
. ${dir_include}/devenv.sh
. ${dir_include}/post_install.sh
. ${dir_include}/stage_vars.sh
# Functions for build systems
. ${dir_include}/make.sh
. ${dir_include}/cmake.sh
. ${dir_include}/meson.sh
# Packages
. ${dir_packages}/bzip2.sh
. ${dir_packages}/libasprintf.sh
. ${dir_packages}/libiconv.sh
. ${dir_packages}/libintl.sh
. ${dir_packages}/libtextstyle.sh
. ${dir_packages}/libtool.sh
. ${dir_packages}/libtre.sh
. ${dir_packages}/libunistring.sh
#. ${dir_packages}/libxml2.sh
. ${dir_packages}/libxml2.cmake.sh
. ${dir_packages}/ncurses.sh
. ${dir_packages}/winpthreads.autotools.sh
#. ${dir_packages}/winpthreads.meson.sh

##
# Stage 1
#

if ${opt_enable_stage1}; then
	stage=1
	. ${dir_include}/env.sh

	# libiconv's `iconv.exe` has circular (optional) dependency on libintl

	libiconv_main
	libintl_main

	if ${opt_ncurses_static}; then :; else
		# we build and install libtool to build ncurses in stage 2
		: libtool_main
	fi
fi

##
# Stage 2
#

if ${opt_enable_stage2}; then
	stage=2
	. ${dir_include}/env.sh

	${WITH_WINPTHREADS} && winpthreads_main

	# almost everything depends on libiconv and libintl

	libiconv_main
	libintl_main

	# nothing depends on libasprintf

	libasprintf_main

	# libgnurx (libsystre) is an optional dependency of ncurses

	libtre_main
	: libgnurx_main # not implemented

	# ncurses is a dependency of readline
	# ncurses is an optional dependency of libtextstyle and gettext
	#
	# libtextstyle is in turn a dependency of gettext

	${WITH_NCURSES} && ncurses_main

	${WITH_READLINE} && : readline_main # not implemented
	libtextstyle_main

	# lzma and zlib are optional dependencies for libxml2

	${WITH_BZIP2} && bzip2_main
	${WITH_LZMA} && : lzma_main # not implemented
	${WITH_ZLIB} && : zlib_main # not implemented

	# optional dependencies for gettext

	libunistring_main
	libxml2_main

	# write PREFIX/devenv.sh

	devenv
fi

##
# Finalize
#

post_install "${PREFIX}" "${u_prefix}"

exit 0
