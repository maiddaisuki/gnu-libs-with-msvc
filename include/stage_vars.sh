#!/bin/sh

##
# The stage_vars function
#

# $1: builddir
# $2: value of *_SRCDIR
#
stage_vars() {

	case $2 in
	/* | ?:[\\/]*)
		srcdir=$2
		;;
	*)
		srcdir=${SRCDIR}/$2
		;;
	esac

	if [ ! -d "${srcdir}" ]; then
		die "${package}: ${srcdir}: directory does not exist"
	fi

	case ${stage} in
	1)
		prefix=${build_prefix}
		;;
	2)
		prefix=${PREFIX}
		;;
	3)
		prefix=${PROGRAMS_PREFIX}
		;;
	*)
		die "invalid stage: ${stage}"
		;;
	esac

	test -d "${prefix}" || install -d "${prefix}" || exit

	local dir
	for dir in bin include lib; do
		test -d "${prefix}/${dir}" || install -d "${prefix}/${dir}" || exit
	done

	local stageroot=${BUILDDIR}/stage-${stage}

	local buildroot=${stageroot}/build
	local cacheroot=${stageroot}/cache
	local destroot=${stageroot}/stage

	builddir=${buildroot}/$1
	test -d "${builddir}" || install -d "${builddir}" || exit

	logdir=${cacheroot}/${package}
	test -d "${logdir}" || install -d "${logdir}" || exit

	statedir=${cacheroot}/${package}
	test -d "${statedir}" || install -d "${statedir}" || exit

	destdir=${destroot}/${package}
	test -d "${destdir}" || install -d "${destdir}" || exit

	pkgdir=${cacheroot}/packages
	test -d "${pkgdir}" || install -d "${pkgdir}" || exit

	pkgfile=${pkgdir}/${package_tar_x}

	return 0
}
