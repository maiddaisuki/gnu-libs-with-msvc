#!/bin/sh

##
# The set_package_vars function
#
# This function sets package-specific variables used by functions defined
# in cmake.sh, make.sh and meson.sh.
#

##
# Arguments:
#
#  $1: package name
#  $2: source directory
#  $3: build directory
#
# Output variables:
#
#  builddir: absolute path to build tree (windows-style)
#  destdir:  absolute path to directory used for staged installation
#  logdir:   absolute path to directory where to store build logs
#  pkgdir:   absolute path to directory where to store created archive
#  pkgfile:  name of archive stored in pkgdir
#  prefix:   installation prefix (windows-style)
#  srcdir:   absolute path to source tree (windows-style)
#  statedir: absolute path to directory where to store timestamp files
#
set_package_vars() {

	case $2 in
	/* | [a-zA-Z]:[\\/]*)
		srcdir=$2
		;;
	*)
		srcdir=${SRCDIR}/$2
		;;
	esac

	if [ ! -d "${srcdir}" ]; then
		die "${package}: srcdir: ${srcdir}: directory does not exist"
	fi

	local buildroot=

	case ${stage} in
	1)
		prefix=${build_prefix}
		buildroot=${BUILDDIR}/stage1
		;;
	2 | 3)
		prefix=${PREFIX}
		buildroot=${BUILDDIR}/stage2
		;;
	*)
		die "stage: ${stage}: invalid value"
		;;
	esac

	test -d "${prefix}" || install -d "${prefix}" || exit

	local dir
	for dir in bin include lib; do
		test -d "${prefix}/${dir}" || install -d "${prefix}/${dir}" || exit
	done

	builddir=${buildroot}/builddir/$3
	test -d "${builddir}" || install -d "${builddir}" || exit

	logdir=${buildroot}/logs/$1
	test -d "${logdir}" || install -d "${logdir}" || exit

	statedir=${buildroot}/state/$1
	test -d "${statedir}" || install -d "${statedir}" || exit

	destdir=${buildroot}/destdir/$1
	test -d "${destdir}" || install -d "${destdir}" || exit

	pkgdir=${buildroot}/packages
	test -d "${pkgdir}" || install -d "${pkgdir}" || exit

	pkgfile=${pkgdir}/${package_tar_x}

	return 0
}
