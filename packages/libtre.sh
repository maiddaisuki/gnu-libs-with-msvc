#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build tre (options as of version 0.9.0)
#
# --enable-nls
#
# --enable-largefile
# --enable-year2038
#
# --enable-approx
# --enable-agrep
# --enable-wchar
# --enable-multibyte
#
# --enable-system-abi
#
# --with-alloca
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libutf8[=DIR]
#
## Developer Options
#
# --enable-warnings
#
# --enable-profile
# --enable-debug
#

libtre_configure() {
	print "${package}: configuring"

	# Dependencies
	local libs=

	# FIXME: required to link against static libintl
	if ! ${build_shared}; then
		libs='-ladvapi32'
	fi

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
		LIBS="${libs}" \
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
	local libs='tre'
	_make_pack
}

libtre_install() {
	_make_install
}

libtre_main() {
	_make_main libtre "${LIBTRE_SRCDIR}"
}
