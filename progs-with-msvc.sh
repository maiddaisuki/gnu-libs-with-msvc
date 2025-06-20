#!/bin/env sh

# Build GNU Programs with MSVC tools

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

opt_host=x86_64-w64-mingw32
opt_env=${selfdir}/vs.sh

opt_toolchain=msvc

opt_buildtype=release
opt_debug=false
opt_static=false
opt_legacy=false

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
	--env=*)
		opt_env=${opt#--env=}
		;;
	--env)
		opt_env=$1 && shift
		;;
	--static)
		opt_static=true
		;;
	--legacy)
		opt_legacy=true
		;;
	--llvm)
		opt_toolchain=llvm
		;;
	--host)
		opt_host=$1
		shift || die "${opt}: missing argument"
		;;
	--host=*)
		opt_host=${opt#--host=}
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
	die "try using --env option"
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
. ${dir_include}/post_install.sh
. ${dir_include}/stage_vars.sh
# Functions for build systems
. ${dir_include}/make.sh
. ${dir_include}/cmake.sh
. ${dir_include}/meson.sh
# Packages
. ${dir_packages}/autoconf.sh
. ${dir_packages}/automake.sh
. ${dir_packages}/bison.sh
. ${dir_packages}/gettext.sh
. ${dir_packages}/libtool.sh
. ${dir_packages}/m4.sh

##
# Build programs
#

stage=3
. ${dir_include}/env.sh

: perl_main

${WITH_M4} && m4_main
${WITH_BISON} && bison_main
: flex_main
${WITH_GETTEXT} && gettext_main

##
# Autotools
#

${WITH_AUTOCONF} && autoconf_main
${WITH_LIBTOOL} && libtool_main
${WITH_AUTOMAKE} && automake_main

##
# Finalize
#

post_install

exit 0
