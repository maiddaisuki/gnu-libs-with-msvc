#!/bin/sh

##
# Generic functions for packages using make as their build system
#

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
		make -k check >>"${test_log}" 2>&1
	else
		make -k "$@" >>"${test_log}" 2>&1
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

##
# Link import and static libraries created by libtool so that
# they can be used with other build systems such as meson and cmake.
#
# Naming convention used by libtool with MSVC is not compatible with
# meson and cmake:
#
# libtool names import libraries LIB.dll.lib; create one link named LIB.lib
#  if such file does not exist yet.
#
# libtool names static libraries LIB.lib; create two links named libLIB.a and
#  libLIB.lib if such files do not exist yet.
#
_make_pack_rename_libs() {
	local lib

	for lib in ${libs}; do
		if ${only_shared}; then
			# link LIB.dll.lib as LIB.lib
			if [ -f lib/${lib}.dll.lib ]; then
				(cd lib && ln ${lib}.dll.lib ${lib}.lib) || exit
			fi
		elif ${only_static}; then
			if [ -f lib/${lib}.lib ]; then
				# link LIB.lib as libLIB.a
				(cd lib && ln ${lib}.lib lib${lib}.a) || exit

				# link LIB.lib as libLIB.lib
				(cd lib && ln ${lib}.lib lib${lib}.lib) || exit
			fi
		else # both
			if [ -f lib/${lib}.dll.lib ] && [ -f lib/${lib}.lib ]; then
				# link LIB.lib as libLIB.a
				(cd lib && ln ${lib}.lib lib${lib}.a) || exit

				# link LIB.lib as libLIB.lib
				(cd lib && ln ${lib}.lib lib${lib}.lib) || exit

			fi
		fi

	done
}

##
# Convert unix-style paths in *.pc files to windows-style paths.
#
_make_pack_patch_pc_files() {
	local file

	if test -d lib/pkgconfig; then
		for file in $(find lib/pkgconfig -name '*.pc'); do
			sed -i "s|${_prefix}|${prefix}|g" $file
		done
	fi

	if test -d share/pkgconfig; then
		for file in $(find share/pkgconfig -name '*.pc'); do
			sed -i "s|${_prefix}|${prefix}|g" $file
		done
	fi
}

_make_pack() {
	print "${package}: creating ${package_tar_x}"

	local old_pwd=$(pwd)

	if test -d "${destdir}${_prefix}"; then
		cd "${destdir}${_prefix}" || exit
	elif test -d "${destdir}${prefix}"; then
		cd "${destdir}${prefix}" || exit
	fi

	_make_pack_rename_libs
	_make_pack_patch_pc_files
	test ${1+y} && $1

	tar -c -f ${package_tar} -h $(dir) &&
		gzip -9 ${package_tar} &&
		mv ${package_tar_x} -t "${pkgdir}"

	test $? -eq 0 || die "${package}: failed to craete ${package_tar_x}"
	cd "${old_pwd}" || exit

	rm -rf "${destdir}"
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

	set_package_vars "${package}" "$3" "${4-${package}}"

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
		${2}_configure
		${2}_build
	fi

	if [ ! -f "${test_stamp}" ] || [ "${build_stamp}" -nt "${test_stamp}" ]; then
		${2}_test
	fi

	if [ ! -f "${pkgfile}" ] || [ "${build_stamp}" -nt "${pkgfile}" ]; then
		${2}_stage
		${2}_pack
	fi

	if [ ! -f "${install_stamp}" ] || [ "${pkgfile}" -nt "${install_stamp}" ]; then
		${2}_install
	fi

	cd "${old_pwd}" || exit
	return 0
}
