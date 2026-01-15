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

##
# For each installed DLL named ${dll_prefix}${lib}${dll_suffix}.dll create
# a link named ${lib}.dll, if it does not exist yet; this makes libtool happy.
#
# For each installed import library named
# ${shared_prefix}${lib}${shared_suffix}.lib create following links if such
# files do not exist yet:
#
#  - ${lib}.dll.lib; this makes it usable with libtool
#  - ${lib}.lib; this makes it usable with pkgconf
#
# For each installed static library named
# ${static_prefix}${lib}${static_suffix}.lib create following links if such
# files do not exist yet:
#
#  - lib${lib}.a
#  - lib${lib}.lib
#  - ${lib}.lib; this makes it usable with libtool and pkgconf
#
_cmake_pack_rename_libs() {
	local dll lib libname

	if [ -d bin ] && [ -n "${libs}" ]; then
		for dll in $(ls bin | grep 'dll$'); do
			for lib in ${libs}; do
				if case ${dll} in ${dll_prefix}${lib}${dll_suffix}.dll) true ;; *) false ;; esac then
					if [ ! -f bin/${lib}.dll ]; then
						(cd bin && ln ${dll} ${lib}.dll) || exit
					fi
				fi
			done
		done
	fi

	for lib in ${libs}; do
		if ${build_shared}; then
			# name of import library
			libname=${shared_prefix}${lib}${shared_suffix}.lib

			if [ -f lib/${libname} ]; then
				# link ${libname} as ${lib}.dll.lib
				(cd lib && ln ${libname} ${lib}.dll.lib) || exit

				# link ${libname} as ${lib}.lib
				if [ ${libname} != ${lib}.lib ] && [ ! -f lib/${lib}.lib ]; then
					(cd lib && ln ${libname} ${lib}.lib) || exit
				fi
			fi
		fi

		if ${build_static}; then
			# name of static library
			libname=${static_prefix}${lib}${static_suffix}.lib

			if [ -f lib/${libname} ]; then
				# link ${libname} as lib${lib}.a
				(cd lib && ln ${libname} lib${lib}.a) || exit

				# link ${libname} as lib${lib}.lib
				if [ ${libname} != lib${lib}.lib ] && [ ! -f lib/lib${lib}.lib ]; then
					(cd lib && ln ${libname} lib${lib}.lib) || exit
				fi

				# link ${libname} as ${lib}.lib
				if [ ${libname} != ${lib}.lib ] && [ ! -f lib/${lib}.lib ]; then
					(cd lib && ln ${libname} ${lib}.lib) || exit
				fi

			fi
		fi
	done
}

_cmake_pack() {
	print "${package}: creating ${package_tar_x}"

	local old_pwd=$(pwd)
	cd "${destdir}" || exit

	_cmake_pack_rename_libs
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

	set_package_vars "${package}" "$3" "${package}"

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

	# cmake-specific options
	local build_shared_libs=OFF
	local build_static_libs=OFF
	local msvc_runtime_library=

	${build_shared} && build_shared_libs=ON
	${build_static} && build_static_libs=ON

	if ${opt_static}; then
		if ${opt_debug}; then
			msvc_runtime_library=MultiThreadedDebug
		else
			msvc_runtime_library=MultiThreaded
		fi
	else
		if ${opt_debug}; then
			msvc_runtime_library=MultiThreadedDebugDLL
		else
			msvc_runtime_library=MultiThreadedDLL
		fi
	fi

	# compiler and linker flags
	local build_cppflags="-D_WIN32_WINNT=${winver}"
	local build_cflags=
	local build_cxxflags=
	local build_ldflags=

	case ${opt_buildtype} in
	release)
		build_cppflags="${build_cppflags} -DNDEBUG"
		build_cflags="-O2 -Ob2"
		build_cxxflags="-O2 -Ob2"
		build_ldflags="-release"
		;;
	small-release)
		build_cppflags="${build_cppflags} -DNDEBUG"
		build_cflags="-O1 -Ob1"
		build_cxxflags="-O1 -Ob1"
		build_ldflags="-release"
		;;
	debug)
		build_cppflags="${build_cppflags}"
		build_cflags="-Od -Ob0 -Z7"
		build_cxxflags="-Od -Ob0 -Z7"
		build_ldflags="-debug"
		;;
	esac

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
