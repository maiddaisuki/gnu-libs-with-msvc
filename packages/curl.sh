#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build curl (options as of version 8.17.0)
#
# --enable-largefile
# --enable-year2038
#
## Features
#
# --enable-curldebug
#
# --enable-libcurl-option
# --enable-manual
# --enable-netrc
# --enable-progress-meter
#
# --with-ca-bundle=FILE
# --with-ca-embed=FILE
# --with-ca-fallback
# --with-ca-path=DIRECTORY
#
# --with-default-ssl-backend=NAME
# --enable-openssl-auto-load-config
# --enable-ssls-export
#
# --enable-alt-svc
# --enable-bindlocal
# --enable-cookies
# --enable-dateparse
# --enable-dnsshuffle
# --enable-ipv6
# --enable-mime
# --enable-sha512-256
# --enable-socketpair
# --enable-threaded-resolver
# --enable-unix-sockets
#
# --enable-aws
# --enable-dict
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
# --enable-ldap
# --enable-ldaps
# --enable-mqtt
# --enable-ntlm
# --enable-pop3
# --enable-proxy
# --enable-rtsp
# --enable-smb
# --enable-smtp
# --enable-telnet
# --enable-tftp
# --enable-websockets
#
# --enable-basic-auth
# --enable-bearer-auth
# --enable-digest-auth
# --enable-http-auth
# --enable-kerberos-auth
# --enable-negotiate-auth
# --enable-tls-srp
#
# [Windows]
#
# --enable-sspi
# --enable-windows-unicode
#
# --enable-ca-search
# --enable-ca-search-safe
#
# [Apple]
#
# --with-apple-sectrust
#
## Interface
#
# --enable-form-api
# --enable-get-easy-options
# --enable-headers-api
#
# --enable-symbol-hiding
# --enable-versioned-symbols
#
## Dependencies
#
# --enable-ares
# --enable-libgcc
# --disable-rt
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
# [Compression]
#
# --with-zlib=PATH
# --with-brotli=PATH
# --with-zstd=PATH
#
# [IDN]
#
# --with-libidn2=PATH
# --with-winidn=PATH
#
# (not applicable)
#
# --with-apple-idn
#
# [SSH]
#
# --with-libssh[=PATH]
# --with-libssh2[=PATH]
#
# [SSL]
#
# --with-gnutls=PATH
# --with-mbedtls=PATH
# --with-openssl=PATH
# --with-rustls=PATH
# --with-schannel
# --with-ssl=PATH
# --with-wolfssl=PATH
#
# (not applicable)
#
# --with-amissl
#
# [HTTP]
#
# --with-nghttp2=PATH
# --with-nghttp3=PATH
# --with-ngtcp2=PATH
# --with-openssl-quic
# --with-quiche=PATH
#
# [LDAP]
#
# --with-ldap=PATH
# --with-ldap-lib=libname
# --with-lber-lib=libname
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
#
# --with-fish-functions-dir=PATH
# --with-zsh-functions-dir=PATH
#
## Misc
#
# --enable-verbose
#
## Developer Options
#
# --enable-code-coverage
# --enable-debug
#

curl_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-sspi
		--enable-windows-unicode

		--with-schannel
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags} -Oi- -we4028" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} -Oi- -we4028" \
		AS="${as}" \
		LD="${ld}" \
		LDFLAGS="${ldflags}" \
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
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
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
