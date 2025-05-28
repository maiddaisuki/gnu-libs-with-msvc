#!/bin/sh

##
# Generic functions for packages using cmake as their build system
#

_cmake_build() {
	print "${package}: building"

	cmake --build . --verbose >>"${build_log}" 2>&1
	test $? -eq 0 || die "${package}: build failed"

	touch "${build_stamp}"
}

_cmake_test() {
	print "${package}: running testsuite"

	ctest . >>"${test_log}" 2>&1

	if test $? -ne 0; then
		warning "${package}: testsuite failed"
	fi

	touch "${test_stamp}"
}

_cmake_stage() {
	print "${package}: staging for packing"
	rm -rf "${destdir}"

	cmake --install . --prefix="${destdir}" >>"${install_log}" 2>&1
	test $? -eq 0 || die "${package}: staged installation failed"
}

_cmake_pack() {
	print "${package}: creating ${package_tar_x}"

	local old_pwd=$(pwd)
	cd "${destdir}" || exit

	test ${1+y} && $1

	tar -c -f ${package_tar} -h $(dir) &&
		gzip -9 ${package_tar} &&
		install ${package_tar_x} "${pkgdir}"

	test $? -eq 0 || die "${package}: failed to craete ${package_tar_x}"
	cd "${old_pwd}" || exit

	rm -rf "${destdir}"
}

_cmake_install() {
	print "${package}: extracting ${package_tar_x}"

	tar -x -f "${_pkgfile}" -C "${_prefix}" || exit
	touch "${install_stamp}"
}

_cmake_main() {
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

	stage_vars "${package}" "$2" "${package}"

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
