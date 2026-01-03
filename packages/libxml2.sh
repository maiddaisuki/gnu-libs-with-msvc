#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libxml2 (options as of version 2.15.1)
#
# --with-docs         [off]
#
## Features
#
# --with-minimum      [off]
# --with-legacy       [off]
#
# --with-reader       [on]
# --with-writer       [on]
#
# --with-html         [on]
# --with-http         [off]
#
# --with-c14n         [on]
# --with-catalog      [on]
# --with-modules      [on]
# --with-output       [on]
# --with-pattern      [on]
# --with-push         [on]
# --with-regexps      [on]
# --with-relaxng      [on]
# --with-sax1         [on]
# --with-schemas      [on]
# --with-schematron   [on]
# --with-valid        [on]
# --with-xinclude     [on]
# --with-xpath        [on]
# --with-xptr         [on]
#
# --with-debug        [on]
#
# --with-threads      [on]
# --with-thread-alloc [off]
# --with-tls          [off]
#
# --with-history      [off]
#
## Dependencies
#
# --with-readline[=DIR]
#
# --with-iconv[=DIR] [on]
# --with-iso8859x    [on]
# --with-icu         [off]
#
# --with-lzma[=DIR]  [off]
#
## Python
#
# --with-python [on]
#
# --with-python_prefix
# --with-python_exec_prefix
# --with-python-sys-prefix
#

libxml2_configure() {
	print "${package}: configuring"

	# Dependencies
	local with_iconv=--with-iconv
	local with_icu=--without-icu

	# Optional dependencies
	local with_readline=--without-readline
	local with_zlib=--without-zlib

	if ${WITH_READLINE}; then
		with_readline=--with-readline
	fi

	if ${WITH_ZLIB}; then
		with_zlib=--with-lzma
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--without-python

		--with-threads
		--with-thread-alloc
		--with-tls

		${with_iconv}
		${with_icu}
		${with_readline}
		${with_zlib}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags} -Oi-" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} -Oi-" \
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

libxml2_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libxml2_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libxml2_stage() {
	_make_stage
}

libxml2_pack() {
	_make_pack
}

libxml2_install() {
	_make_install
}

libxml2_main() {
	_make_main libxml2 "${LIBXML2_SRCDIR}"
}
