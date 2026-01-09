#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build json-c (options as of version 0.18)
#
# BUILD_SHARED_LIBS={ON|OFF}
# BUILD_STATIC_LIBS={ON|OFF}
#
# DISABLE_STATIC_FPIC={ON|OFF}
# DISABLE_BSYMBOLIC={ON|OFF}
#
# DISABLE_WERROR={ON|OFF}
#
## Features
#
# DISABLE_JSON_POINTER={ON|OFF}
#
# ENABLE_RDRAND={ON|OFF}
# OVERRIDE_GET_RANDOM_SEED=STRING
#
# ENABLE_THREADING={ON|OFF}
# DISABLE_THREAD_LOCAL_STORAGE={ON|OFF}
#
## Dependecies
#
# DISABLE_EXTRA_LIBS={ON|OFF}
#

json_c_configure() {
	print "${package}: configuring"

	local options="
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_MSVC_RUNTIME_LIBRARY=${msvc_runtime_library}

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		-DBUILD_STATIC_LIBS=${build_static_libs}

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

json_c_build() {
	_cmake_build
}

json_c_test() {
	# Tests are shell scripts and cannot be run on native Windows
	if ${ENABLE_TESTS}; then
		: _cmake_test
	fi
}

json_c_stage() {
	_cmake_stage
}

json_c_pack() {
	local libs='json-c'
	local dll_prefix=
	local dll_suffix=
	local shared_prefix=
	local shared_suffix=
	if ${build_shared}; then
		local static_prefix=
		local static_suffix='-static'
	else
		local static_prefix=
		local static_suffix=
	fi
	_cmake_pack
}

json_c_install() {
	_cmake_install
}

json_c_main() {
	_cmake_main json-c json_c "${JSON_C_SRCDIR}"
}
