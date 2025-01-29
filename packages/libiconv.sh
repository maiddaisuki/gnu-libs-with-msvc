#!/bin/env sh

# Build libiconv

## configure options as of libiconv 1.18
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
#
# --disable-largefile
# --enable-year2038
#
# --enable-extra-encodings
# --disable-nls
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-gnulib-prefix=DIR
#

libiconv_configure() {
	print "${package}: configuring"

	local enable_nls=--disable-nls
	local enable_extra_encodings=--disable-extra-encodings

	if [ ${stage} = 2 ]; then
		enable_nls=--enable-nls
		enable_extra_encodings=--enable-extra-encodings
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		${enable_nls}
		${enable_extra_encodings}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		${configure_options} \
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
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

libiconv_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libiconv_test() {
	if ${MAKE_CHECK}; then
		_make_test -i check
	fi
}

libiconv_stage() {
	_make_stage
}

libiconv_pack() {
	_make_pack
}

libiconv_install() {
	_make_install
}

libiconv_main() {
	_make_main libiconv "${LIBICONV_SRCDIR}"
}
