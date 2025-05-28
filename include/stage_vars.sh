#!/bin/sh

##
# The stage_vars function
#

# $1: package name
# $2: srcdir
# $3: builddir
#
stage_vars() {

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
	2)
		prefix=${PREFIX}
		buildroot=${BUILDDIR}/stage2
		;;
	3)
		prefix=${PROGRAMS_PREFIX}
		buildroot=${BUILDDIR}/stage3
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
