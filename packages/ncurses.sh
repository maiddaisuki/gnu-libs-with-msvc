#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + libtool)

##
# Build ncurses (options as of version 6.5)
#

## Options required for native Windows build:
#
# --enable-exp-win32
# --enable-term-driver
#

## Features
#
# --disable-ext-funcs
# --enable-ext-colors
# --enable-ext-mouse
# --enable-ext-putwin
#
# --enable-sp-funcs
#
# --enable-tcap-names
#
# --enable-colorfgbg (experemental)
# --enable-no-padding
#
# --disable-hashmap
# --disable-scroll-hints
#
# --enable-check-size
# --enable-hard-tabs
# --enable-wgetch-events (experemental)
# --enable-xmc-glitch (experemental)
#
# --disable-big-core
# --disable-big-strings
#
# --disable-largefile
# --enable-string-hacks
#
# [compatibility options]
#
# --disable-assumed-color
# --enable-bsdpad
# --enable-safe-sprintf
#
## POSIX Threads
#
# --with-pthread
#
# --enable-pthreads-eintr
# --enable-weak-symbols
# --enable-reentrant
#
# --enable-sigwinch
#
## Other (not for Windows)
#
# --with-x11-rgb=FILE
#
# --disable-root-environ
# --disable-root-access
#
# --disable-setuid-environ
#

## Interface
#
# --disable-lp64
#
# --enable-const
# --enable-stdnoreturn
#
# --disable-opaque-curses
# --disable-opaque-form
# --disable-opaque-menu
# --disable-opaque-panel
#
# --enable-interop
#
# --with-wrap-prefix=XXX
#
## Functions
#
# --disable-tparm-varargs
# --enable-wattr-macros
#
## Types
#
# --enable-signed-char
#
# --with-bool=TYPE
#
# --with-chtype=TYPE
# --with-ospeed=TYPE
# --with-mmask-t=TYPE
#
# --with-ccharw-max=XXX
#
# --with-tparm-arg=TYPE
#

## Library
#
# --disable-widec
#
# --without-cxx
# --without-cxx-binding
#
# --without-ada
#
# [cannot be used on Windows]
#
# --with-termlib
# --with-ticlib
#
# --disable-tic-depends
#
## Header files
#
# --without-curses-h
#
## Library names
#
# --disable-overwrite
# --disable-lib-suffixes
#
# --with-lib-prefix=PREFIX
#
# --with-extra-suffix[=X]
#
# --with-form-libname[=XXX]
# --with-menu-libname[=XXX]
# --with-panel-libname[=XXX]
#
# --with-cxx-libname[=XXX]
#
## Versioning
#
# --with-rel-version=XXX
# --with-abi-version=XXX
# --with-abi-altered=XXX
#
## pkg-config
#
# --enable-pc-files
#
# --with-pc-suffix[=XXX]
#
# --with-pkg-config[=CMD]
# --with-pkg-config-libdir[=XXX]
#
# --disable-pkg-ldflags
#
## Other (not for Windows)
#
# --with-shlib-version[={rel|abi}]
# --with-export-syms[=FILENAME]
# --with-versioned-syms[=FILENAME]
#
# --enable-fvisibility
#

## Build
#
# --without-progs
#
# --with-libtool
# --with-libtool-opts[=XXX]
# --disable-libtool-version
#
# --enable-rpath
# --disable-rpath-hack
# --disable-relink
#
# --enable-broken_linker
#
# --with-shared
# --with-normal
#
# --with-cxx-shared
#
# --with-debug
# --with-profile
#
# --disable-echo
#
# --with-rcs-ids
#
## Ada
#
# --with-ada-compiler[=CMD]
#
# --with-ada-include=DIR
# --with-ada-objects=DIR
#
# --with-ada-sharedlib
# --with-ada-libname[=XXX]
#
## Cross-compilation
#
# --with-build-cc=XXX
# --with-build-cpp=XXX
# --with-build-cflags=XXX
# --with-build-cppflags=XXX
# --with-build-ldflags=XXX
# --with-build-libs=XXX
#

## Dependencies
#
# --with-pcre2
#
# [Linux]
#
# --with-gpm
# --without-dlsym
#
# [BSD]
#
# --with-hashed-db
#
# --with-sysmouse
#

## Terminfo Database
#
# --with-database=XXX
#
# --with-default-terminfo-dir=DIR
# --with-terminfo-dirs=XXX
#
# --disable-home-terminfo
#
# --disable-db-install
#
## tic
#
# --enable-mixed-case
# --enable-symlinks
#
## xterm
#
# --without-xterm-new
# --with-xterm-kbs[=XXX]
#
## Terminfo Fallback Entries
#
# --disable-database
#
# --with-fallbacks=XXX
#
# --with-infocmp-path=XXX
# --with-tic-path=XXX
#

## Termcap Database
#
# --enable-termcap
# --with-termpath=XXX (default=/etc/termcap:/usr/share/misc/termcap)
#
# --with-caps=alt
#
# [bsd]
#
# --enable-getcap
# --enable-getcap-cache
#

## Installation
#
# --with-config-suffix=SUFFIX
#
# --disable-stripping
# --with-strip-program=XX
#
# Manual pages
#
# --without-manpages
#
# --with-manpage-format={gzip|compress|bzip2|xz|BSDI|normal}[,formatted|catonly]
# --with-manpage-renames
# --with-manpage-aliases
# --with-manpage-symlinks
# --with-manpage-tbl
#

## Developer Options
#
# --without-develop
# --without-tests
#
# --enable-warnings
# --enable-assertions
#
# --enable-expanded
# --disable-macros
#
# --with-dmalloc
# --with-dbmalloc
#
# --with-valgrind
# --disable-leaks
#
# --with-trace
# --disable-gnat-projects
#
# --with-system-type=XXX
#

ncurses_configure() {
	print "${package}: configuring"

	# Library types
	local with_normal='--without-normal'
	local with_shared='--without-shared --without-cxx-shared'

	# libtool and options
	local libtool=${u_build_prefix}/bin/libtool
	local libtool_opts

	if ${build_shared} && ${build_static}; then
		libtool_opts='-no-undefined'
	elif ${build_shared}; then
		libtool_opts="-no-undefined -shared"
	else # only static
		libtool_opts="-static"
	fi

	if ${build_shared}; then
		with_shared='--with-shared --with-cxx-shared'
	fi

	if ${build_static}; then
		with_normal=--with-normal
	fi

	local configure_options="
		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${with_normal}
		${with_shared}

		--without-debug
		--without-profile

		--without-progs
		--without-tests

		--without-ada

		--with-cxx
		--with-cxx-binding

		--enable-exp-win32
		--enable-term-driver

		--enable-ext-funcs
		--disable-ext-colors

		--enable-sp-funcs
		--enable-interop

		--enable-opaque-curses
		--enable-opaque-form
		--enable-opaque-menu
		--enable-opaque-panel

		--enable-overwrite
		--enable-widec
		--disable-lib-suffixes

		--disable-termcap
		--with-default-terminfo-dir=${_prefix}/share/terminfo

		--enable-mixed-case
		--disable-symlinks

		--enable-pc-files
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
		LIBS='-luser32' \
		PKG_CONFIG_LIBDIR="${u_prefix}/lib/pkgconfig:${u_prefix}/share/pkgconfig" \
		PKG_CONFIG_PATH= \
		${configure_options} \
		--with-libtool="${libtool}" \
		--with-libtool-opts="${libtool_opts}" \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

ncurses_build() {
	_make_build CFLAGS="${cflags}" CXXFLAGS="${cxxflags}"
}

ncurses_test() {
	if ${MAKE_CHECK}; then
		: _make_test
	fi
}

ncurses_stage() {
	_make_stage install
}

ncurses_pack_hook() {
	local old_pwd=$(pwd)

	# Cygwin: Replace symbolic links with files they refer to
	local dir link target

	for dir in $(find $(pwd) -type d); do
		cd $dir || exit

		for link in $(find -maxdepth 1 -type l); do
			target=$(readlink $link)
			rm -f $link
			cp -RL $target $link || exit
		done
	done

	cd "${old_pwd}" || exit
}

ncurses_pack() {
	local libs='form menu ncurses ncurses++ panel'
	_make_pack ncurses_pack_hook
}

ncurses_install() {
	_make_install
}

ncurses_main() {
	_make_main ncurses ncurses "${NCURSES_SRCDIR}"
}
