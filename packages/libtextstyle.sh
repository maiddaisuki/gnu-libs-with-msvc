#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libtextstyle (options as of gettext 0.26)
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

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	# Dependencies
	local enable_curses=--disable-curses

	if ${WITH_NCURSES}; then
		enable_curses=--enable-curses

		local ncurses_cflags=
		local ncurses_ldflags=

		if ${build_shared}; then
			ncurses_cflags=$(${PKG_CONFIG} --cflags ncurses)
			ncurses_ldflags=$(${PKG_CONFIG} --libs ncurses)
		else
			ncurses_cflags=$(${PKG_CONFIG} --static --cflags ncurses)
			ncurses_ldflags=$(${PKG_CONFIG} --static --libs ncurses)
		fi

		build_cppflags="${build_cppflags} ${ncurses_cflags}"
		build_libs="${build_libs} ${ncurses_ldflags}"
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
		--enable-threads=windows
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/libtextstyle/configure \
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

libtextstyle_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
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
	local libs='textstyle'
	_make_pack
}

libtextstyle_install() {
	_make_install
}

libtextstyle_main() {
	_make_main libtextstyle libtextstyle "${GETTEXT_SRCDIR}" gettext/libtextstyle
}
