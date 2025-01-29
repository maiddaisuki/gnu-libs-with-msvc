#!/bin/env sh

# Build gettext

## configure options for gettext 0.23
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
#
# --disable-namespacing
#
# --disable-libasprintf
#
# --disable-largefile
# --enable-year2038
#
# --disable-acl
# --disable-curses
# --disable-openmp
#
# --disable-c++
# --enable-csharp[=dotnet|mono]
# --disable-java
#
# --enable-threads=isoc|posix|isoc+posix|windows
# --disable-nls
#
# [not for windows]
#
# --disable-xattr
#
## Dependencies
#
# --without-libsmack
# --without-emacs
#
# --with-bison-prefix=DIR
#
# --without-included-regex
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-included-gettext
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-libtermcap-prefix[=DIR]
# --without-libtermcap-prefix
#
# --with-libcurses-prefix[=DIR]
# --without-libcurses-prefix
#
# --with-libncurses-prefix[=DIR]
# --without-libncurses-prefix
#
# --with-libxcurses-prefix[=DIR]
# --without-libxcurses-prefix
#
# --with-installed-libtextstyle
# --with-libtextstyle-prefix[=DIR]
# --without-libtextstyle-prefix
#
# --with-included-libunistring
# --with-libunistring-prefix[=DIR]
# --without-libunistring-prefix
#
# --with-included-libxml
# --with-libxml2-prefix[=DIR]
# --without-libxml2-prefix
#
# --with-installed-csharp-dll
#
# --without-git
# --with-cvs
# --without-bzip2
# --without-xz
#
# [not for windows]
#
# --without-selinux
#
## Installation
#
# --with-lispdir
#
## Other
#
# --enable-more-warnings
#

gettext_configure() {
	print "${package}: configuring"

	local enable_nls=--enable-nls

	local enable_curses=--disable-curses
	local libs=

	if ${WITH_NCURSES}; then
		enable_curses=--enable-curses

		if ${opt_ncurses_static}; then
			libs="-Wl,user32.lib"
		fi
	fi

	local enable_threads=windows

	if ${WITH_WINPTHREADS}; then
		enable_threads=posix
		local cppflags="${cppflags} -FIpthread_compat.h"
	fi

	local with_emacs=--without-emacs

	if ${WITH_EMACS}; then
		with_emacs=--with-emacs
	fi

	#	${enable_shared}
	#	${enable_static}

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=x86_64-pc-mingw64

		--disable-shared
		--enable-static

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		--enable-libasprintf

		--enable-c++
		--disable-csharp
		--disable-java

		${enable_nls}
		${enable_curses}
		--enable-threads=${enable_threads}

		${with_emacs}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/gettext-tools/configure \
		-C \
		YACC="$(cygpath -m "${PREFIX}/bin/bison.exe") -y" \
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

	test $? -eq 0 || die "configuring ${package} has failed"
}

gettext_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

gettext_test() {
	if ${MAKE_CHECK}; then
		_make_test -i check
	fi
}

gettext_stage() {
	_make_stage
}

gettext_pack() {
	_make_pack
}

gettext_install() {
	_make_install
}

gettext_main() {
	_make_main gettext "${GETTEXT_SRCDIR}"
}
