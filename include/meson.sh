#!/bin/sh

##
# Generic functions for packages using meson as their build system
#

meson_args() {
	local arg args

	for arg in "$@"; do
		if [ -z "${args}" ]; then
			args="'${arg}'"
		else
			args="${args}, '${arg}'"
		fi
	done

	printf '[%s]' "${args}"
}

_meson_build() {
	print "${package}: building"

	meson compile --verbose >>"${build_log}" 2>&1
	test $? -eq 0 || die "${package}: build failed"

	touch "${build_stamp}"
}

_meson_test() {
	print "${package}: running testsuite"

	meson test --verbose >>"${test_log}" 2>&1

	if test $? -ne 0; then
		warning "${package}: testsuite failed"
	fi

	touch "${test_stamp}"
}

_meson_stage() {
	print "${package}: staging for packing"
	rm -rf "${destdir}"

	meson install --destdir="${destdir}" >>"${install_log}" 2>&1
	test $? -eq 0 || die "${package}: staged installation failed"
}

_meson_pack() {
	print "${package}: creating ${package_tar_x}"

	local _prefix_no_drive=$(printf %s "${prefix}" | sed 's|^.:[\/]|/|')

	local old_pwd=$(pwd)
	cd "${destdir}${_prefix_no_drive}" || exit

	test ${1+y} && $1

	tar -c -f ${package_tar} -h $(dir) &&
		gzip -9 ${package_tar} &&
		install ${package_tar_x} "${pkgdir}"

	test $? -eq 0 || die "${package}: failed to craete ${package_tar_x}"
	cd "${old_pwd}" || exit

	rm -rf "${destdir}"
}

_meson_install() {
	print "${package}: extracting ${package_tar_x}"

	tar -x -f "${_pkgfile}" -C "${_prefix}" || exit
	touch "${install_stamp}"
}

_meson_main() {
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

	export CC="${c_compiler}"
	export CXX="${cxx_compiler}"

	if [ ! -f "${build_stamp}" ]; then
		${package}_configure
		${package}_build
	fi

	unset CC CXX

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
