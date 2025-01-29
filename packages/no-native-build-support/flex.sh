#!/bin/env sh

# Build flex

## configure options for flex 2.6.4
#
# --enable-warnings
# --disable-bootstrap
#
# --disable-nls
# --disable-libfl
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#

flex_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=x86_64-pc-mingw64

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-nls
		--enable-libfl
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
		LIBS=-ltre \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

flex_build() {
	: _make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

flex_test() {
	if ${MAKE_CHECK}; then
		: _make_test -i check
	fi
}

flex_stage() {
	: _make_stage
}

flex_pack() {
	: _make_pack
}

flex_install() {
	: _make_install
}

flex_main() {
	_make_main flex "${FLEX_SRCDIR}"
}
