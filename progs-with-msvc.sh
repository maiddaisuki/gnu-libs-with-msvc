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

##
## Helper functions
##

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
## Parse options
##

opt_host=x86_64-w64-mingw32
opt_env=${selfdir}/vs.sh

opt_toolchain=msvc

opt_static=false
opt_legacy=false

opt_with_autotools=false

while [ $# -gt 0 ]; do
	opt=$1 && shift

	case ${opt} in
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
	--with-autotools)
		opt_with_autotools=true
		;;
	*)
		die "${opt}: unrecognized option"
		;;
	esac
done

##
## Read configs
##

if [ -f "${opt_env}" ]; then
	. ${opt_env}
else
	error "${opt_env}: file does not exist"
	die "try using --env option"
fi

if ! type cl.exe >/dev/null 2>&1; then
	die "cl.exe is not found in PATH"
fi

. ${selfdir}/config/dirs.sh
. ${selfdir}/config/flags.sh
. ${selfdir}/config/options.sh
. ${selfdir}/config/packages.sh

##
## Read scripts with functions
##

dir_include=${selfdir}/include
dir_packages=${selfdir}/packages

. ${dir_include}/verify.sh

# helpers

. ${dir_include}/post_install.sh
. ${dir_include}/stage_vars.sh

. ${dir_include}/make.sh
. ${dir_include}/cmake.sh
. ${dir_include}/meson.sh

# packages

. ${dir_packages}/autoconf.sh
. ${dir_packages}/automake.sh
. ${dir_packages}/bison.sh
. ${dir_packages}/gettext.sh
. ${dir_packages}/libtool.sh
. ${dir_packages}/m4.sh

##
## Build
##

. ${dir_include}/stage3.sh

: perl_main

m4_main
bison_main
: flex_main

gettext_main

if ${opt_with_autotools}; then
	autoconf_main
	automake_main
	libtool_main
fi

post_install "${PROGRAMS_PREFIX}" "${u_programs_prefix}"

exit 0
