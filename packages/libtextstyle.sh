#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libtextstyle (options as of gettext 0.25)
#
# --enable-curses
# --enable-namespacing
#
## gnulib options
#
# --enable-cross-guesses=conservative|risky
# --enable-largefile
# --enable-year2038
# --enable-threads=isoc|posix|isoc+posix|windows
#
# --with-gnulib-prefix=DIR
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libtermcap-prefix[=DIR]
# --with-libcurses-prefix[=DIR]
# --with-libncurses-prefix[=DIR]
# --with-libxcurses-prefix[=DIR]
#
## Developer options
#
# --enable-more-warnings
#

libtextstyle_configure() {
	print "${package}: configuring"

	# Dependencies
	local enable_curses=--disable-curses
	local libs=

	if ${WITH_NCURSES}; then
		enable_curses=--enable-curses

		if ${opt_static}; then
			libs="-Wl,user32.lib"
		fi
	fi

	# Features
	local enable_threads=windows

	if ${WITH_WINPTHREADS}; then
		enable_threads=posix
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		${enable_curses}
		--enable-threads=${enable_threads}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/libtextstyle/configure \
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

libtextstyle_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libtextstyle_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libtextstyle_stage() {
	_make_stage
}

libtextstyle_pack() {
	_make_pack
}

libtextstyle_install() {
	_make_install
}

libtextstyle_main() {
	_make_main libtextstyle "${GETTEXT_SRCDIR}" gettext/libtextstyle
}
