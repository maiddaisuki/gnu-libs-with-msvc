#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build curl (options as of version 8.17.0)
#
# BUILD_SHARED_LIBS={ON|OFF}
# BUILD_STATIC_LIBS={ON|OFF}
#
# BUILD_CURL_EXE={ON|OFF}                 [ON]
# BUILD_STATIC_CURL={ON|OFF}              [OFF]
#
# LIBCURL_OUTPUT_NAME=STRING              [libcurl]
#
# CURL_LIBCURL_SOVERSION={ON|OFF}         [OFF]
# CURL_LIBCURL_VERSIONED_SYMBOLS={ON|OFF} [OFF]
#
# PICKY_COMPILER={ON|OFF}                 [ON]
# CURL_WERROR={ON|OFF}                    [OFF]
# CURL_LTO={ON|OFF}                       [OFF]
#
# BUILD_EXAMPLES={ON|OFF}                 [ON]
#
# [Windows]
#
# CURL_TARGET_WINDOWS_VERSION=STRING
# CURL_STATIC_CRT={ON|OFF}
#
## Features
#
# CURL_ENABLE_SSL={ON|OFF}                       [ON]
# CURL_DISABLE_OPENSSL_AUTO_LOAD_CONFIG={ON|OFF} [OFF]
# USE_SSLS_EXPORT={ON|OFF}                       [OFF]
#
# ENABLE_UNIX_SOCKETS={ON|OFF}                   [ON]
# ENABLE_THREADED_RESOLVER={ON|OFF}              [ON]
#
# USE_ECH={ON|OFF}                               [OFF]
# USE_HTTPSRR={ON|OFF}                           [OFF]
#
# ENABLE_CURLDEBUG={ON|OFF}                      [OFF]
#
# [Windows]
#
# CURL_WINDOWS_SSPI={ON|OFF}      [OFF]
# ENABLE_UNICODE={ON|OFF}         [OFF]
#
# CURL_CA_SEARCH_SAFE={ON|OFF}    [OFF]
# CURL_DISABLE_CA_SEARCH={ON|OFF} [OFF]
#
## Dependencies
#
# CURL_USE_PKGCONFIG={ON|OFF} [OFF]
#
# CURL_USE_LIBUV={ON|OFF}
# ENABLE_ARES={ON|OFF}
# USE_LIBRTMP={ON|OFF}
#
# CURL_BROTLI={AUTO|ON|OFF}   [AUTO]
# CURL_ZLIB={AUTO|ON|OFF}     [AUTO]
# CURL_ZSTD={AUTO|ON|OFF}     [AUTO]
#
# [IDN]
#
# USE_LIBIDN2={ON|OFF}
# USE_WIN32_IDN={ON|OFF}
#
# [SSL]
#
# CURL_USE_GNUTLS={ON|OFF}
# CURL_USE_MBEDTLS={ON|OFF}
# CURL_USE_OPENSSL={ON|OFF}
# CURL_USE_RUSTLS={ON|OFF}
# CURL_USE_SCHANNEL={ON|OFF}
# CURL_USE_WOLFSSL={ON|OFF}
#
# [HTTP]
#
# USE_NGHTTP2={ON|OFF}
# USE_NGTCP2={ON|OFF}
# USE_OPENSSL_QUIC={ON|OFF}
# USE_QUICHE={ON|OFF}
#
# [LDAP]
#
# USE_WIN32_LDAP={ON|OFF}
#
## Tests
#
# BUILD_TESTING={ON|OFF} [ON]
#
## Installation
#
# CURL_DISABLE_INSTALL={ON|OFF} [OFF]
#
# CURL_COMPLETION_FISH={ON|OFF} [OFF]
# CURL_COMPLETION_ZSH={ON|OFF}  [OFF]
#
# ENABLE_CURL_MANUAL{ON|OFF}    [ON]
# BUILD_LIBCURL_DOCS={ON|OFF}   [ON]
# BUILD_MISC_DOCS={ON|OFF}      [ON]
#
## Developer Options
#
# ENABLE_DEBUG={ON|OFF}       [OFF]
#
# CURL_CLANG_TIDY={ON|OFF}    [OFF]
# CURL_CODE_COVERAGE={ON|OFF} [OFF]
#

curl_configure() {
	print "${package}: configuring"

	# Features
	local static_crt=OFF
	local static_curl=OFF

	if ${opt_static}; then
		static_crt=ON
	fi

	if ! ${build_shared}; then
		static_curl=ON
	fi

	# Whether to use pkgconf to find dependencies
	local use_pkgconfig=OFF

	if ${WITH_PKGCONF} && { ${onyl_shared} || ${only_static}; }; then
		use_pkgconfig=ON
	fi

	# Compression libraries
	local use_brotli=OFF
	local use_zlib=OFF
	local use_zstd=OFF

	if ${WITH_ZLIB}; then
		use_zlib=ON
	fi

	# IDN libraries
	local use_libidn2=OFF
	local use_win32_idn=ON

	if ${WITH_LIBIDN2}; then
		use_libidn2=ON
		use_win32_idn=OFF
	fi

	# SSL libraries: OpenSSL and wolfSSL are mutually exclusive
	local use_gnutls=OFF
	local use_mbedtls=OFF
	local use_openssl=OFF
	local use_rusttls=OFF
	local use_schannel=ON
	local use_wolfssl=OFF

	# HTTP libraries
	local use_nghttp2=OFF
	local use_ngtcp2=Off
	local use_openssl_quic=OFF
	local use_quiche=OFF

	# LDAP libraries
	local use_win32_ldap=ON

	# Misc
	local use_ares=OFF
	local use_librtmp=OFF

	local options="
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_MSVC_RUNTIME_LIBRARY=${msvc_runtime_library}
		-DCURL_STATIC_CRT=${static_crt}
		-DBUILD_STATIC_CURL=${static_curl}

		-DBUILD_SHARED_LIBS=${build_shared_libs}
		-DBUILD_STATIC_LIBS=${build_static_libs}
		-DBUILD_EXAMPLES=OFF

		-DCMAKE_INSTALL_PREFIX=${prefix}
		-DCMAKE_INSTALL_LIBDIR=lib

		-DENABLE_UNICODE=ON
		-DCURL_TARGET_WINDOWS_VERSION=${winver}
		-DCURL_WINDOWS_SSPI=ON

		-DCURL_USE_PKGCONFIG=${use_pkgconfig}

		-DCURL_BROTLI=${use_brotli}
		-DCURL_ZLIB=${use_zlib}
		-DCURL_ZSTD=${use_zstd}

		-DUSE_LIBIDN2=${use_libidn2}
		-DUSE_WIN32_IDN=${use_win32_idn}

		-DUSE_NGHTTP2=${use_nghttp2}
		-DUSE_NGTCP2=${use_ngtcp2}
		-DUSE_OPENSSL_QUIC=${use_openssl_quic}
		-DUSE_QUICHE=${use_quiche}

		-DCURL_USE_GNUTLS=${use_gnutls}
		-DCURL_USE_MBEDTLS=${use_mbedtls}
		-DCURL_USE_OPENSSL=${use_openssl}
		-DCURL_USE_RUSTLS=${use_rusttls}
		-DCURL_USE_SCHANNEL=${use_schannel}
		-DCURL_USE_WOLFSSL=${use_wolfssl}

		-DUSE_WIN32_LDAP=${use_win32_ldap}

		-DENABLE_ARES=${use_ares}
		-DUSE_LIBRTMP=${use_librtmp}
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

curl_build() {
	_cmake_build
}

curl_test() {
	if ${ENABLE_TESTS}; then
		_cmake_test
	fi
}

curl_stage() {
	_cmake_stage
}

curl_pack() {
	local libs='curl'
	local dll_prefix='lib'
	local dll_suffix=
	local shared_prefix='lib'
	local shared_suffix='_imp'
	local static_prefix='lib'
	local static_suffix=
	_cmake_pack
}

curl_install() {
	_cmake_install
}

curl_main() {
	_cmake_main curl curl "${CURL_SRCDIR}" true
}
