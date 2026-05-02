#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build curl (options as of version 8.17.0)
#
# --enable-largefile
# --enable-year2038
#
# [Windows]
#
# --enable-windows-unicode
#

## CA
#
# --with-ca-bundle=FILE
# --with-ca-embed=FILE
# --with-ca-fallback
# --with-ca-path=DIRECTORY
#
# [Windows]
#
# --enable-ca-search
# --enable-ca-search-safe
#

## SSL
#
# --with-default-ssl-backend=NAME
#
# --enable-ssls-export
#
# [Windows]
#
# --enable-sspi
#
# [OpenSSL]
#
# --enable-openssl-auto-load-config
#

## Features
#
# --enable-curldebug
# --enable-libcurl-option
#
# --enable-alt-svc
# --enable-aws
# --enable-bindlocal
# --enable-cookies
# --enable-dateparse
# --enable-dict
# --enable-dnsshuffle
# --enable-doh
# --enable-ech
# --enable-file
# --enable-ftp
# --enable-gopher
# --enable-hsts
# --enable-http
# --enable-httpsrr
# --enable-imap
# --enable-ipfs
# --enable-ipv6
# --enable-ldap
# --enable-ldaps
# --enable-mime
# --enable-mqtt
# --enable-netrc
# --enable-ntlm
# --enable-pop3
# --enable-progress-meter
# --enable-proxy
# --enable-rtsp
# --enable-sha512-256
# --enable-smb
# --enable-smtp
# --enable-socketpair
# --enable-telnet
# --enable-tftp
# --enable-threaded-resolver
# --enable-tls-srp
# --enable-unix-sockets
# --enable-verbose
# --enable-websockets
#
# --enable-basic-auth
# --enable-bearer-auth
# --enable-digest-auth
# --enable-http-auth
# --enable-kerberos-auth
# --enable-negotiate-auth
#

## Interface
#
# --enable-symbol-hiding
#
# --enable-form-api
# --enable-get-easy-options
# --enable-headers-api
#
# --enable-versioned-symbols
#

## Dependencies
#
# --enable-ares
# --enable-libgcc
# --enable-rt
#
# --with-libgsasl=PATH
# --with-libpsl=PATH
# --with-librtmp=PATH
# --with-libuv=PATH
#
# --with-gssapi=DIR
# --with-gssapi-includes=DIR
# --with-gssapi-libs=DIR
#
# [Apple]
#
# --with-apple-sectrust
#
## Compression Libraries
#
# --with-brotli=PATH
# --with-zlib=PATH
# --with-zstd=PATH
#
## HTTP Libraries
#
# --with-nghttp2=PATH
# --with-nghttp3=PATH
# --with-ngtcp2=PATH
# --with-openssl-quic
# --with-quiche=PATH
#
## IDN Libraries
#
# --with-libidn2=PATH
# --with-winidn=PATH
#
# [Apple]
#
# --with-apple-idn
#
## LDAP Libraries
#
# --with-ldap=PATH
# --with-ldap-lib=libname
# --with-lber-lib=libname
#
## SSH Libraries
#
# --with-libssh[=PATH]
# --with-libssh2[=PATH]
#
## SSL Libraries
#
# --with-gnutls=PATH
# --with-mbedtls=PATH
# --with-openssl=PATH
# --with-rustls=PATH
# --with-schannel
# --with-ssl=PATH
# --with-wolfssl=PATH
#
# [Amiga]
#
# --with-amissl
#

## Build
#
# --enable-optimize
# --enable-warnings
# --enable-werror
#
# --enable-unity
#

## Tests
#
# --with-test-caddy=PATH
# --with-test-danted=PATH
# --with-test-httpd=PATH
# --with-test-nghttpx=PATH
# --with-test-vsftpd=PATH
#

## Installation
#
# --enable-docs
# --enable-manual
#
# --with-fish-functions-dir=PATH
# --with-zsh-functions-dir=PATH
#

## Developer Options
#
# --enable-debug
# --enable-code-coverage
#

curl_configure() {
	print "${package}: configuring"

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	# configure will error out if compiler does not issue an error diagnostic
	# on mismatching function declaration.
	build_cflags='-we4028'
	build_cxxflags='-we4028'

	# Features
	local enable_warnings=--disable-warnings

	if [ ${opt_toolchain} = llvm ]; then
		enable_warnings=--enable-warnings
	fi

	# Misc libraries
	local with_ares=--disable-ares
	local with_libgsasl=--without-libgsasl
	local with_lgssapi=--without-gssapi
	local with_libpsl=--without-libpsl
	local with_librtmp=--without-librtmp
	local with_libuv=--without-libuv

	# FIXME: do not enforce dependency on libpsl
	if true; then
		with_libpsl=--with-libpsl
	fi

	# Compression libraries
	local with_brotli=--without-brotli
	local with_zlib=--without-zlib
	local with_zstd=--without-zstd

	if ${WITH_ZLIB}; then
		with_zlib=--with-zlib
	fi

	# HTTP libraries
	local with_nghttp2=--without-nghttp2
	local with_nghttp3=--without-nghttp3
	local with_ngtcp2=--without-ngtcp2
	local with_openssl_quic=--without-openssl-quic
	local with_quiche=--without-quiche

	# IDN libraries
	local with_libidn2=--without-libidn2
	local with_winidn=--without-winidn

	if ${WITH_LIBIDN2}; then
		with_libidn2=--with-libidn2
	else
		with_winidn=--with-winidn
	fi

	# LDAP libraries
	local with_ldap= # with --without-ldap, configure attempts to use openldap; this is not what we want

	# SSH libraries
	local with_libssh=--without-libssh
	local with_libssh2=--without-libssh2

	# SSL libraries
	local with_gnutls=--without-gnutls
	local with_mbedtls=--without-mbedtls
	local with_openssl=--without-openssl
	local with_rustls=--without-rustls
	local with_schannel='--without-schannel --disable-sspi'
	local with_wolfsls=--without-wolfssl

	# TODO: currently we do not support building any SSL libraries
	if true; then
		with_schannel='--with-schannel --enable-sspi'
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-windows-unicode
		${enable_warnings}

		${with_ares}
		${with_libgsasl}
		${with_lgssapi}
		${with_libpsl}
		${with_librtmp}
		${with_libuv}

		${with_brotli}
		${with_zlib}
		${with_zstd}

		${with_nghttp2}
		${with_nghttp3}
		${with_ngtcp2}
		${with_openssl_quic}
		${with_quiche}

		${with_libidn2}
		${with_winidn}

		${with_ldap}

		${with_libssh}
		${with_libssh2}

		${with_gnutls}
		${with_mbedtls}
		${with_openssl}
		${with_rustls}
		${with_schannel}
		${with_wolfsls}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		CC="${cc}" \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags} -Oi-" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags} -Oi-" \
		AS="${as}" \
		LD="${ld}" \
		LDFLAGS="${ldflags} ${build_ldflags}" \
		LIBS="${build_libs}" \
		AR="${ar}" \
		RANLIB="${ranlib}" \
		NM="${nm}" \
		OBJDUMP="${objdump}" \
		OBJCOPY="${objcopy}" \
		STRIP="${strip}" \
		DLLTOOL="${dlltool}" \
		${configure_options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

curl_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

curl_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

curl_stage() {
	_make_stage
}

curl_pack() {
	local libs='curl'
	_make_pack
}

curl_install() {
	_make_install
}

curl_main() {
	_make_main curl curl "${CURL_SRCDIR}"
}
