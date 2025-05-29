#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build tre (options as of version 0.9.0)
#
# --disable-nls
#
# --disable-largefile
# --enable-year2038
#
# --disable-approx
# --disable-agrep
# --disable-wchar
# --disable-multibyte
#
# --enable-system-abi
#
# --without-alloca
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-libutf8[=DIR]
# --without-libutf8
#
## Developer Options
#
# --disable-warnings
#
# --enable-profile
# --enable-debug
#

libtre_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${host_opt}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-nls
		--disable-agrep

		--without-alloca
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

libtre_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libtre_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libtre_stage() {
	_make_stage
}

libtre_pack() {
	_make_pack
}

libtre_install() {
	_make_install
}

libtre_main() {
	_make_main libtre "${TRE_SRCDIR}"
}
