#!/bin/env sh

# Build PACKAGE

## CMake options as of PACKAGE VERSION
#
# (list options here)
#

PACKAGE_configure() {
	print "${package}: configuring"

	local options="
	"

	cmake -S "${srcdir}" -B . --fresh \
		${options} \
		-DBUILD_SHARED_LIBS=${build_shared_libs} \
		-DCMAKE_BUILD_TYPE=${cmake_build_type} \
		-DCMAKE_MSVC_RUNTIME_LIBRARY=${msvc_runtime_library} \
		-DCMAKE_C_COMPILER="${c_compiler}" \
		-DCMAKE_C_FLAGS="${CPPFLAGS} ${CFLAGS}" \
		-DCMAKE_CXX_COMPILER="${cxx_compiler}" \
		-DCMAKE_CXX_FLAGS="${CPPFLAGS} ${CXXFLAGS}" \
		-DCMAKE_INSTALL_PREFIX="${prefix}" \
		-DCMAKE_INSTALL_LIBDIR=lib \
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
	_cmake_pack
}

PACKAGE_install() {
	_cmake_install
}

PACKAGE_main() {
	_cmake_main PACKAGE "${package_SRCDIR}"
}
