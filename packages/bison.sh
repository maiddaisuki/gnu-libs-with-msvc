#!/bin/env sh

# Build bison

## configure options for bison 3.8.2
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
#
# --disable-largefile
# --disable-year2038
#
# --disable-nls
# --enable-threads=isoc|posix|isoc+posix|windows
#
# --disable-yacc
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-libreadline-prefix[=DIR]
# --without-libreadline-prefix
#
# --with-libtextstyle-prefix[=DIR]
# --without-libtextstyle-prefix
#
# --enable-gcc-warnings
# --disable-assert
#

bison_configure() {
	print "${package}: configuring"

	local enable_nls=--enable-nls
	local enable_threads=windows

	if ${WITH_WINPTHREADS}; then
		enable_threads=posix
		local cppflags="${cppflags} -FIpthread_compat.h"
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		--enable-yacc

		${enable_nls}
		--enable-threads=${enable_threads}

		--disable-assert
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		M4="$(cygpath -m "${PREFIX}/bin/m4.exe")" \
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

bison_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

bison_test() {
	if ${MAKE_CHECK}; then
		_make_test -i check
	fi
}

bison_stage() {
	_make_stage
}

bison_pack() {
	_make_pack
}

bison_install() {
	_make_install
}

bison_main() {
	_make_main bison "${BISON_SRCDIR}"
}
