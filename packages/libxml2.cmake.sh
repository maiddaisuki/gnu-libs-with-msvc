#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build libxml2 (options as of version 2.14.3)
#
# LIBXML2_WITH_PROGRAMS [ON]
# LIBXML2_WITH_TESTS [ON]
#
# LIBXML2_XMLCONF_WORKING_DIR=DIR
#
## Features
#
# LIBXML2_WITH_LEGACY [OFF]
#
# LIBXML2_WITH_READER [ON]
# LIBXML2_WITH_WRITER [ON]
#
# LIBXML2_WITH_HTML [ON]
# LIBXML2_WITH_HTTP [OFF]
#
# LIBXML2_WITH_C14N         [ON]
# LIBXML2_WITH_CATALOG      [ON]
# LIBXML2_WITH_MODULES      [ON]
# LIBXML2_WITH_OUTPUT       [ON]
# LIBXML2_WITH_PATTERN      [ON]
# LIBXML2_WITH_PUSH         [ON]
# LIBXML2_WITH_REGEXPS      [ON]
# LIBXML2_WITH_RELAXNG      [ON]
# LIBXML2_WITH_SAX1         [ON]
# LIBXML2_WITH_SCHEMAS      [ON]
# LIBXML2_WITH_SCHEMATRON   [ON]
# LIBXML2_WITH_TREE         [ON]
# LIBXML2_WITH_VALID        [ON]
# LIBXML2_WITH_XINCLUDE     [ON]
# LIBXML2_WITH_XPATH        [ON]
# LIBXML2_WITH_XPTR         [ON]
#
# LIBXML2_WITH_DEBUG        [ON]
#
# LIBXML2_WITH_THREADS      [ON]
# LIBXML2_WITH_THREAD_ALLOC [OFF]
# LIBXML2_WITH_TLS          [OFF]
#
## Dependencies
#
# LIBXML2_WITH_ISO8859X [ON]
# LIBXML2_WITH_ICONV    [ON]
# LIBXML2_WITH_ICU      [OFF]
# LIBXML2_WITH_LZMA     [OFF]
# LIBXML2_WITH_PYTHON   [OFF]
# LIBXML2_WITH_READLINE [OFF]
# LIBXML2_WITH_ZLIB     [OFF]
#

libxml2_configure() {
	print "${package}: configuring"

	# Optional dependencies
	local with_lzma=OFF
	local with_readline=OFF
	local with_zlib=OFF

	if ${WITH_LZMA}; then
		with_lzma=ON
	fi

	if ${WITH_READLINE}; then
		with_readline=ON
	fi

	if ${WITH_ZLIB}; then
		with_zlib=ON
	fi

	# Features
	local with_programs=ON

	local options="
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_MSVC_RUNTIME_LIBRARY=${msvc_runtime_library}

		-DBUILD_SHARED_LIBS=${build_shared_libs}

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=lib

		-DLIBXML2_WITH_PROGRAMS=${with_programs}

		-DLIBXML2_WITH_THREADS=ON
		-DLIBXML2_WITH_THREAD_ALLOC=ON
		-DLIBXML2_WITH_TLS=ON

		-DLIBXML2_WITH_ICONV=ON
		-DLIBXML2_WITH_LZMA=${with_lzma}
		-DLIBXML2_WITH_PYTHON=OFF
		-DLIBXML2_WITH_READLINE=${with_readline}
		-DLIBXML2_WITH_ZLIB=${with_zlib}
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

libxml2_build() {
	_cmake_build
}

libxml2_test() {
	if ${ENABLE_TESTS}; then
		_cmake_test
	fi
}

libxml2_stage() {
	_cmake_stage
}

libxml2_pack_hook() {
	# make libtool happy

	if [ -f bin/libxml2.dll ]; then
		(cd bin && ln libxml2.dll xml2.dll) || exit

		if [ -f lib/libxml2.lib ]; then
			(cd lib && ln libxml2.lib xml2.dll.lib) || exit
		fi
	fi

	if [ -f lib/libxml2s.lib ]; then
		(cd lib && ln libxml2s.lib xml2.lib) || exit
	fi
}

libxml2_pack() {
	_cmake_pack libxml2_pack_hook
}

libxml2_install() {
	_cmake_install
}

libxml2_main() {
	_cmake_main libxml2 "${LIBXML2_SRCDIR}"
}
