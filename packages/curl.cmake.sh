#!/bin/sh

# BUILD_SYSTEM: cmake

##
# Build curl (options as of version 8.20)
#
# BUILD_SHARED_LIBS={ON|OFF} [ON]
# BUILD_STATIC_LIBS={ON|OFF} [OFF]
#
# BUILD_CURL_EXE={ON|OFF}    [ON]
# BUILD_STATIC_CURL={ON|OFF} [OFF]
#
# CURL_BUILD_EVERYTHING={ON|OFF} [OFF]
#
# BUILD_EXAMPLES={ON|OFF}    [ON]
#
# [Windows]
#
# CURL_STATIC_CRT={ON|OFF} [OFF]
# CURL_TARGET_WINDOWS_VERSION=STRING
# ENABLE_UNICODE={ON|OFF}  [OFF]
#
# [library name]
#
# LIBCURL_OUTPUT_NAME=STRING [libcurl]
# IMPORT_LIB_SUFFIX=STRING   [_imp]
# STATIC_LIB_SUFFIX=STRING   []
#
# [not applicable]
#
# CURL_LIBCURL_SOVERSION={ON|OFF} [OFF]
#

## CA
#
# CURL_CA_BUNDLE={STRING|auto|none} [auto]
# CURL_CA_EMBED=STRING              []
# CURL_CA_FALLBACK={ON|OFF}         [OFF]
# CURL_CA_NATIVE={ON|OFF}           [OFF]
# CURL_CA_PATH={STRING|auto|none}   [auto]
#
# [Windows]
#
# CURL_DISABLE_CA_SEARCH={ON|OFF} [OFF]
# CURL_CA_SEARCH_SAFE={ON|OFF}    [OFF]
#

## SSL
#
# CURL_ENABLE_SSL={ON|OFF} [ON]
# CURL_DEFAULT_SSL_BACKEND={wolfssl|gnutls|mbedtls|openssl|schannel|rustls}
#
# USE_SSLS_EXPORT={ON|OFF} [OFF]
#
# [Windows]
#
# CURL_WINDOWS_SSPI={ON|OFF} [OFF]
#
# [OpenSSL]
#
# CURL_DISABLE_OPENSSL_AUTO_LOAD_CONFIG={ON|OFF} [OFF]
#

## Features
#
# CURL_DISABLE_LIBCURL_OPTION={ON|OFF}  [OFF]
# CURL_PATCHSTAMP=STRING
#
# HTTP_ONLY={ON|OFF}                    [OFF]
#
# CURL_DISABLE_ALTSVC={ON|OFF}          [OFF]
# CURL_DISABLE_AWS={ON|OFF}             [OFF]
# CURL_DISABLE_BINDLOCAL={ON|OFF}       [OFF]
# CURL_DISABLE_COOKIES={ON|OFF}         [OFF]
# CURL_DISABLE_PARSEDATE={ON|OFF}       [OFF]
# CURL_DISABLE_DICT={ON|OFF}            [OFF]
# CURL_DISABLE_SHUFFLE_DNS={ON|OFF}     [OFF]
# CURL_DISABLE_DOH={ON|OFF}             [OFF]
# USE_ECH={ON|OFF}                      [OFF]
# CURL_DISABLE_FILE={ON|OFF}            [OFF]
# CURL_DISABLE_FTP={ON|OFF}             [OFF]
# CURL_DISABLE_GOPHER={ON|OFF}          [OFF]
# CURL_DISABLE_HSTS={ON|OFF}            [OFF]
# CURL_DISABLE_HTTP={ON|OFF}            [OFF]
# USE_HTTPSRR={ON|OFF}                  [OFF]
# CURL_DISABLE_IMAP={ON|OFF}            [OFF]
# CURL_DISABLE_IPFS={ON|OFF}            [OFF]
# ENABLE_IPV6={ON|OFF}                  [ON]
# CURL_DISABLE_LDAP={ON|OFF}            [OFF]
# CURL_DISABLE_LDAPS={ON|OFF}           [CURL_DISABLE_LDAP]
# CURL_DISABLE_MIME={ON|OFF}            [OFF]
# CURL_DISABLE_MQTT={ON|OFF}            [OFF]
# CURL_DISABLE_NETRC={ON|OFF}           [OFF]
# CURL_ENABLE_NTLM={ON|OFF}             [OFF]
# CURL_DISABLE_POP3={ON|OFF}            [OFF]
# CURL_DISABLE_PROGRESS_METER={ON|OFF}  [OFF]
# CURL_DISABLE_PROXY={ON|OFF}           [OFF]
# CURL_DISABLE_RTSP={ON|OFF}            [OFF]
# CURL_DISABLE_SHA512_256={ON|OFF}      [OFF]
# CURL_ENABLE_SMB={ON|OFF}              [OFF]
# CURL_DISABLE_SMTP={ON|OFF}            [OFF]
# CURL_DISABLE_SOCKETPAIR={ON|OFF}      [OFF]
# CURL_DISABLE_TELNET={ON|OFF}          [OFF]
# CURL_DISABLE_TFTP={ON|OFF}            [OFF]
# ENABLE_THREADED_RESOLVER={ON|OFF}     [ON]
# CURL_DISABLE_SRP={ON|OFF}             [OFF]
# CURL_DISABLE_TYPECHECK={ON|OFF}       [OFF]
# ENABLE_UNIX_SOCKETS={ON|OFF}          [ON]
# CURL_DISABLE_VERBOSE_STRINGS={ON|OFF} [OFF]
# CURL_DISABLE_WEBSOCKETS={ON|OFF}      [ON]
#
# CURL_DISABLE_BASIC_AUTH={ON|OFF}     [OFF]
# CURL_DISABLE_BEARER_AUTH={ON|OFF}    [OFF]
# CURL_DISABLE_DIGEST_AUTH={ON|OFF}    [OFF]
# CURL_DISABLE_HTTP_AUTH={ON|OFF}      [OFF]
# CURL_DISABLE_KERBEROS_AUTH={ON|OFF}  [OFF]
# CURL_DISABLE_NEGOTIATE_AUTH={ON|OFF} [OFF]
#

## Interface
#
# CURL_HIDDEN_SYMBOLS={ON|OFF}      [ON]
#
# CURL_DISABLE_FORM_API={ON|OFF}    [CURL_DISABLE_MIME]
# CURL_DISABLE_GETOPTIONS={ON|OFF}  [OFF]
# CURL_DISABLE_HEADERS_API={ON|OFF} [OFF]
#
# CURL_LIBCURL_VERSIONED_SYMBOLS={ON|OFF}      [OFF]
# CURL_LIBCURL_VERSIONED_SYMBOLS_PREFIX=STRING
#

## Dependencies
#
# CURL_USE_CMAKECONFIG={ON|OFF} [ON]
# CURL_USE_PKGCONFIG={ON|OFF}   [OFF]
#
# ENABLE_ARES={ON|OFF} [OFF]
#   CARES_INCLUDE_DIR
#   CARES_LIBRARY
#   CARES_USE_STATIC_LIBS
#
# CURL_USE_GSASL={ON|OFF} [OFF]
#   LIBGSASL_INCLUDE_DIR
#   LIBGSASL_LIBRARY
#
# CURL_USE_LIBPSL={ON|OFF} [ON]
#   LIBPSL_INCLUDE_DIR
#   LIBPSL_LIBRARY
#
# CURL_USE_LIBUV={ON|OFF} [OFF]
#   LIBUV_INCLUDE_DIR
#   LIBUV_LIBRARY
#
# CURL_USE_GSSAPI={ON|OFF} [OFF]
#   GSS_ROOT_DIR
#
# [Apple]
#
# USE_APPLE_SECTRUST={ON|OFF}
#
# [???]
#
# NETTLE_INCLUDE_DIR
# NETTLE_LIBRARY
#
# WATT_ROOT
#
# [Not applicable]
#
# CURL_USE_LIBBACKTRACE={ON|OFF}
#   LIBBACKTRACE_INCLUDE_DIR
#   LIBBACKTRACE_LIBRARY
#
## Compression Libraries
#
# CURL_BROTLI={AUTO|ON|OFF} [AUTO]
#   BROTLI_INCLUDE_DIR=
#   BROTLICOMMON_LIBRARY
#   BROTLIDEC_LIBRARY
#   BROTLI_USE_STATIC_LIBS
#
# CURL_ZLIB={AUTO|ON|OFF} [AUTO]
#   ZLIB_INCLUDE_DIR
#   ZLIB_LIBRARY
#   ZLIB_USE_STATIC_LIBS
#
# CURL_ZSTD={AUTO|ON|OFF} [AUTO]
#   ZSTD_INCLUDE_DIR
#   ZSTD_LIBRARY
#   ZSTD_USE_STATIC_LIBS
#
## HTTP Libraries
#
# USE_NGHTTP2={ON|OFF} [ON]
#   NGHTTP2_INCLUDE_DIR
#   NGHTTP2_LIBRARY
#   NGHTTP2_USE_STATIC_LIBS
#
# USE_NGTCP2={ON|OFF} [OFF]
#   NGHTTP3_INCLUDE_DIR
#   NGHTTP3_LIBRARY
#   NGHTTP3_USE_STATIC_LIBS
#   NGTCP2_INCLUDE_DIR
#   NGTCP2_LIBRARY
#   NGTCP2_CRYPTO_BORINGSSL_LIBRARY
#   NGTCP2_CRYPTO_GNUTLS_LIBRARY
#   NGTCP2_CRYPTO_LIBRESSL_LIBRARY
#   NGTCP2_CRYPTO_OSSL_LIBRARY
#   NGTCP2_CRYPTO_QUICTLS_LIBRARY
#   NGTCP2_CRYPTO_WOLFSSL_LIBRARY
#   NGTCP2_USE_STATIC_LIBS
#
# USE_QUICHE={ON|OFF} [OFF]
#   QUICHE_INCLUDE_DIR
#   QUICHE_LIBRARY
#
## IDN Libraries
#
# USE_LIBIDN2={ON|OFF} [ON]
#   LIBIDN2_INCLUDE_DIR
#   LIBIDN2_LIBRARY
#
# USE_WIN32_IDN={ON|OFF} [OFF]
#
# [Apple]
#
# USE_APPLE_IDN={ON|OFF}
#
## LDAP Libraries
#
# USE_WIN32_LDAP={ON|OFF} [ON]
#
# LDAP_INCLUDE_DIR
# LDAP_LIBRARY
# LDAP_LBER_LIBRARY
#
## SSH Libraries
#
# CURL_USE_LIBSSH={ON|OFF} [OFF]
#   LIBSSH_INCLUDE_DIR
#   LIBSSH_LIBRARY
#   LIBSSH_USE_STATIC_LIBS
#
# CURL_USE_LIBSSH2={ON|OFF} [ON]
#   LIBSSH2_INCLUDE_DIR
#   LIBSSH2_LIBRARY
#   LIBSSH2_USE_STATIC_LIBS
#
## SSL Libraries
#
# BORINGSSL_VERSION=STRING
#
# CURL_USE_GNUTLS={ON|OFF} [OFF]
#   GNUTLS_INCLUDE_DIR
#   GNUTLS_LIBRARY
#
# CURL_USE_MBEDTLS={ON|OFF} [OFF]
#   MBEDTLS_INCLUDE_DIR
#   MBEDCRYPTO_LIBRARY
#   MBEDTLS_LIBRARY
#   MBEDX509_LIBRARY
#   MBEDTLS_USE_STATIC_LIBS
#
# CURL_USE_OPENSSL={ON|OFF} [ON]
#   OPENSSL_ROOT_DIR
#   OPENSSL_INCLUDE_DIR
#   OPENSSL_SSL_LIBRARY
#   OPENSSL_CRYPTO_LIBRARY
#   OPENSSL_USE_STATIC_LIBS
#
# CURL_USE_RUSTLS={ON|OFF} [OFF]
#   RUSTLS_INCLUDE_DIR
#   RUSTLS_LIBRARY
#   DL_LIBRARY
#   MATH_LIBRARY
#   PTHREAD_LIBRARY
#
# CURL_USE_SCHANNEL={ON|OFF} [OFF]
#
# CURL_USE_WOLFSSL={ON|OFF} [OFF]
#  WOLFSSL_INCLUDE_DIR
#  WOLFSSL_LIBRARY
#  MATH_LIBRARY
#
# [Amiga]
#
# AMISSL_INCLUDE_DIR
# AMISSL_AUTO_LIBRARY
# AMISSL_STUBS_LIBRARY
#

## Build
#
# SHARE_LIB_OBJECT={ON|OFF} [ON]
#
# PICKY_COMPILER={ON|OFF}   [ON]
# CURL_WERROR={ON|OFF}      [OFF]
#
# CURL_DROP_UNUSED={ON|OFF} [OFF]
# CURL_LTO={ON|OFF}         [OFF]
#

## Tests
#
# BUILD_TESTING={ON|OFF} [ON]
#
## Programs
#
# PERL_EXECUTABLE=STRING
#
# APXS=STRING          [apxs]
# CADDY=STRING         [caddy]
# DANTED=STRING        [danted]
# HTTPD=STRING         [apache2]
# HTTPD_NGHTTPX=STRING [nghttpx]
# TEST_NGHTTPX=STRING  [nghttpx]
# SFTPD=STRING         [sftp-server]
# SSHD=STRING          [sshd]
# VSFTPD=STRING        [vsftps]
#

## Installation
#
# CURL_DISABLE_INSTALL={ON|OFF} [OFF]
#
# CURL_ENABLE_EXPORT_TARGET={ON|OFF} [ON]
#
# CURL_COMPLETION_FISH={ON|OFF}   [OFF]
# CURL_COMPLETION_FISH_DIR=STRING []
#
# CURL_COMPLETION_ZSH={ON|OFF}    [OFF]
# CURL_COMPLETION_ZSH_DIR=STRING  []
#
# ENABLE_CURL_MANUAL={ON|OFF}   [ON]
# BUILD_LIBCURL_DOCS={ON|OFF}   [ON]
# BUILD_MISC_DOCS={ON|OFF}      [ON]
#

## Developer Options
#
# ENABLE_DEBUG={ON|OFF}       [OFF]
#
# CURL_GCC_ANALYZER={ON|OFF}  [OFF]
#
# CLANG_TIDY=STRING           [clang-tidy]
# CURL_CLANG_TIDY={ON|OFF}    [OFF]
# CURL_CLANG_TIDYFLAGS=STRING []
#
# CURL_CODE_COVERAGE={ON|OFF} [OFF]
# CURL_LINT={ON|OFF}          [OFF]
#

curl_configure() {
	print "${package}: configuring"

	# Features
	local static_crt=OFF
	local static_curl=OFF
	local windows_sspi=OFF

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

	# Misc libraries
	local use_ares=OFF
	local use_gsasl=OFF
	local use_libpsl=OFF
	local use_libuv=OFF
	local use_gssapi=OFF

	if ${WITH_LIBPSL}; then
		use_libpsl=ON
	fi

	# Compression libraries
	local use_brotli=OFF
	local use_zlib=OFF
	local use_zstd=OFF

	if ${WITH_ZLIB}; then
		use_zlib=ON
	fi

	# HTTP libraries
	local use_nghttp2=OFF
	local use_ngtcp2=Off
	local use_quiche=OFF

	# IDN libraries
	local use_libidn2=OFF
	local use_win32_idn=OFF

	if ${WITH_LIBIDN2}; then
		use_libidn2=ON
	else
		use_win32_idn=ON
	fi

	# LDAP libraries
	local use_win32_ldap=ON

	# SSH libraries
	local use_libssh=OFF
	local use_libssh2=OFF

	# SSL libraries: OpenSSL and wolfSSL are mutually exclusive
	local use_gnutls=OFF
	local use_mbedtls=OFF
	local use_openssl=OFF
	local use_rustls=OFF
	local use_schannel=OFF
	local use_wolfssl=OFF

	# TODO: currently we do not support building any SSL libraries
	if true; then
		windows_sspi=ON
		use_schannel=ON
	fi

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
		-DCURL_WINDOWS_SSPI=${windows_sspi}

		-DCURL_USE_PKGCONFIG=${use_pkgconfig}

		-DENABLE_ARES=${use_ares}
		-DCURL_USE_GSASL=${use_gsasl}
		-DCURL_USE_LIBPSL=${use_libpsl}
		-DCURL_USE_LIBUV=${use_libuv}
		-DCURL_USE_GSSAPI=${use_gssapi}

		-DCURL_BROTLI=${use_brotli}
		-DCURL_ZLIB=${use_zlib}
		-DCURL_ZSTD=${use_zstd}

		-DUSE_NGHTTP2=${use_nghttp2}
		-DUSE_NGTCP2=${use_ngtcp2}
		-DUSE_QUICHE=${use_quiche}

		-DUSE_LIBIDN2=${use_libidn2}
		-DUSE_WIN32_IDN=${use_win32_idn}

		-DUSE_WIN32_LDAP=${use_win32_ldap}

		-DCURL_USE_LIBSSH=${use_libssh}
		-DCURL_USE_LIBSSH2=${use_libssh2}

		-DCURL_USE_GNUTLS=${use_gnutls}
		-DCURL_USE_MBEDTLS=${use_mbedtls}
		-DCURL_USE_OPENSSL=${use_openssl}
		-DCURL_USE_RUSTLS=${use_rustls}
		-DCURL_USE_SCHANNEL=${use_schannel}
		-DCURL_USE_WOLFSSL=${use_wolfssl}
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
