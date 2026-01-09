#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build PACKAGE (options as of VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
	print "${package}: configuring"

	local options="
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_MSVC_RUNTIME_LIBRARY=${msvc_runtime_library}

		-DBUILD_SHARED_LIBS=${build_shared_libs}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=lib
	"

	cmake -S "${srcdir}" -B . --fresh \
		-DCMAKE_C_COMPILER="${c_compiler}" \
		-DCMAKE_C_FLAGS="${CPPFLAGS} ${CFLAGS}" \
		-DCMAKE_C_FLAGS_RELEASE="${build_cppflags} ${build_cflags}" \
		-DCMAKE_CXX_COMPILER="${cxx_compiler}" \
		-DCMAKE_CXX_FLAGS="${CPPFLAGS} ${CXXFLAGS}" \
		-DCMAKE_CXX_FLAGS_RELEASE="${build_cppflags} ${build_cxxflags}" \
		-DCMAKE_EXE_LINKER_FLAGS="${build_ldflags} ${LDFLAGS}" \
		-DCMAKE_SHARED_LINKER_FLAGS="${build_ldflags} ${LDFLAGS}" \
		${options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

PACKAGE_build() {
	_cmake_build
}

PACKAGE_test() {
	if ${ENABLE_TESTS}; then
		_cmake_test
	fi
}

PACKAGE_stage() {
	_cmake_stage
}

PACKAGE_pack() {
	# This variable should contain space-separated list of libraries
	# installed by this packages.
	#
	# This list may contain libraries which may not be installed,
	# for example, if their installation is optional.
	#
	# If package installs libfoo and libbar, this list may contain 'foo bar'.
	# If package does not install any libraries, leave this list empty.
	#
	# If default _cmake_pack_rename_libs function is unable to correctly rename
	# package's libraries, you may need to write custom PACKAGE_pack_hook
	# function. In this case, leave this list empty.
	local libs=''
	# Prefix and suffix of installed DLLs, so that
	# ${dll_prefix}${lib}${dll_suffix}.dll will match names of installed DLLs.
	#
	# These two may contain shell wildcards such as '*'.
	local dll_prefix=
	local dll_suffix=
	# Prefix and suffix of installed import libraries, so that
	# ${shared_prefix}${lib}${shared_suffix}.lib will match names of installed
	# import libraries.
	local shared_prefix=
	local shared_suffix=
	# Prefix and suffix of installed static libraries, so that
	# ${shared_prefix}${lib}${shared_suffix}.lib will match names of installed
	# static libraries.
	local static_prefix=
	local static_suffix=
	_cmake_pack
}

PACKAGE_install() {
	_cmake_install
}

PACKAGE_main() {
	_cmake_main PACKAGE "${package_SRCDIR}"
}
