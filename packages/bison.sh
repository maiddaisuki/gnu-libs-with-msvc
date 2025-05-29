#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build bison (options as of version 3.8.2)
#
# --enable-nls
# --enable-yacc
#
## gnulib
#
# --enable-cross-guesses=conservative|risky
# --enable-largefile
# --enable-relocatable
# --enable-threads=isoc|posix|isoc+posix|windows
# --enable-year2038
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libreadline-prefix[=DIR]
# --with-libtextstyle-prefix[=DIR]
#
## Developer options
#
# --enable-gcc-warnings
# --enable-assert
#

bison_configure() {
	print "${package}: configuring"

	# Features
	local enable_assert=--disable-assert
	local enable_threads=windows

	if [ ${opt_buildtype} = debug ]; then
		enable_assert=--enable-assert
	fi

	if ${WITH_WINPTHREADS}; then
		enable_threads=posix
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		--enable-yacc

		${enable_assert}
		--enable-nls
		--enable-threads=${enable_threads}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		M4="$(cygpath -m "${PROGRAMS_PREFIX}/bin/m4.exe")" \
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
	# Fix for out-of-tree build
	test -d examples || cp -Rp ${_srcdir}/examples -t . || exit
}

bison_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

bison_test() {
	if ${MAKE_CHECK}; then
		_make_test
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
