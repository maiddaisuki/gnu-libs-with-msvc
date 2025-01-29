#!/bin/env sh

# Generic functions for configure-based packages

_make_build() {
	print "${package}: building"

	if [ $# -eq 0 ]; then
		make ${MAKE_JOBS} >>"${build_log}" 2>&1
	else
		make ${MAKE_JOBS} "$@" >>"${build_log}" 2>&1
	fi

	test $? -eq 0 || die "${package}: build failed"
	touch "${build_stamp}"
}

_make_test() {
	print "${package}: running testsuite"

	if [ $# -eq 0 ]; then
		make check >>"${test_log}" 2>&1
	else
		make "$@" >>"${test_log}" 2>&1
	fi

	if test $? -ne 0; then
		warning "${package}: testsuite failed"
	fi

	touch "${test_stamp}"
}

_make_stage() {
	print "${package}: staging for packing"

	rm -rf "${destdir}${_prefix}" "${destdir}${prefix}"

	if [ $# -eq 0 ]; then
		make ${destdir_var-DESTDIR}="${destdir}" install-strip >>"${install_log}" 2>&1
	else
		make ${destdir_var-DESTDIR}="${destdir}" "$@" >>"${install_log}" 2>&1
	fi

	test $? -eq 0 || die "${package}: staged installation failed"
}

_make_pack() {
	print "${package}: creating ${package_tar_x}"

	local old_pwd=$(pwd)

	if test -d "${destdir}${_prefix}"; then
		cd "${destdir}${_prefix}" || exit
	elif test -d "${destdir}${prefix}"; then
		cd "${destdir}${prefix}" || exit
	fi

	test ${1+y} && $1

	tar -c -f ${package_tar} -h $(dir) &&
		gzip -9 ${package_tar} &&
		mv ${package_tar_x} -t "${pkgdir}"

	test $? -eq 0 || die "${package}: failed to craete ${package_tar_x}"
	cd "${old_pwd}" || exit
}

_make_install() {
	print "${package}: extracting ${package_tar_x}"

	tar -x -f "${_pkgfile}" -C "${_prefix}" || exit
	touch "${install_stamp}"
}

_make_main() {
	local package=$1

	local package_tar=${package}.tar
	local package_tar_x=${package_tar}.gz

	local prefix

	local srcdir
	local builddir

	local logdir
	local statedir

	local destdir
	local pkgdir
	local pkgfile

	stage_vars "${3-${package}}" "$2"

	local _srcdir=$(cygpath -u "${srcdir}")
	local _prefix=$(cygpath -u "${prefix}")
	local _pkgfile=$(cygpath -u "${pkgfile}")

	local configure_log=${logdir}/configure.log
	local build_log=${logdir}/build.log
	local test_log=${logdir}/test.log
	local install_log=${logdir}/install.log

	local build_stamp=${statedir}/built
	local test_stamp=${statedir}/tested
	local install_stamp=${statedir}/installed

	local old_pwd=$(pwd)
	cd "${builddir}" || exit

	if [ ! -f "${build_stamp}" ]; then
		${package}_configure
		${package}_build
	fi

	if [ ! -f "${test_stamp}" ] || [ "${build_stamp}" -nt "${test_stamp}" ]; then
		${package}_test
	fi

	if [ ! -f "${pkgfile}" ] || [ "${build_stamp}" -nt "${pkgfile}" ]; then
		${package}_stage
		${package}_pack
	fi

	if [ ! -f "${install_stamp}" ] || [ "${pkgfile}" -nt "${install_stamp}" ]; then
		${package}_install
	fi

	cd "${old_pwd}" || exit
	return 0
}
