#!/bin/env sh

# Build ncurses

## configure options as of ncurses 6.5
#
# These are required for native windows build:
#
# --enable-exp-win32
# --enable-term-driver
#
## Other
#
# --with-config-suffix=X
# --with-x11-rgb=FILE
#
## ???
#
# --with-rcs-ids
#

## Features
#
# --disable-largefile
#
# --disable-ext-funcs
#
# --enable-ext-colors
# --enable-ext-mouse
# --enable-ext-putwin
#
# --enable-const
# --enable-sp-funcs
#
# --enable-tcap-names
#
# --enable-colorfgbg (experemental)
# --enable-no-padding
#
# --disable-hashmap
# --disable-scroll-hints (to be used with --disable-hashmap)
#
# --enable-check-size
# --enable-hard-tabs
# --enable-wgetch-events (experemental)
# --enable-xmc-glitch (experemental)
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
## (not for windows)
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
# --with-termlib
# --with-ticlib
#
# --disable-tic-depends
#
# --without-cxx
# --without-cxx-binding
#
# --without-ada
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
## Other (not for windows)
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
## Other
#
# --enable-string-hacks
#
# --disable-big-core
# --disable-big-strings
#

## Dependencies
#
# --with-pcre2
#
# [linux]
#
# --with-gpm
# --without-dlsym
#
# [bsd]
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
	if ${opt_ncurses_workaround}; then
		return
	fi

	print "${package}: configuring"

	local with_normal
	local with_shared

	local libtool
	local libtool_opts

	local with_libtool
	local with_libtool_opts

	if ${opt_ncurses_static}; then
		with_normal=--with-normal
		with_shared='--without-shared --without-cxx-shared'

		with_libtool=--without-libtool
		with_libtool_opts=--without-libtool-opts
	else
		libtool=$(cygpath -u "${BUILD_PREFIX}/bin/libtool")

		case ,${enable_shared},${enable_static}, in
		,*enable*,*enable*,)
			libtool_opts='-no-undefined'
			;;
		,*disable*,*,)
			libtool_opts="-static"
			;;
		,*enable*,*,)
			libtool_opts="-no-undefined -shared"
			;;
		esac

		case ${enable_shared} in
		*enable*)
			with_shared='--with-shared --with-cxx-shared'
			;;
		*disable*)
			with_shared='--without-shared --without-cxx-shared'
			;;
		esac

		case ${enable_static} in
		*enable*)
			with_normal=--with-normal
			;;
		*disable)
			with_normal=--without-normal
			;;
		esac

		with_libtool="--with-libtool=${libtool}"
		with_libtool_opts="--with-libtool-opts=${libtool_opts}"
	fi

	#	--with-ticlib
	#	--with-termlib
	#
	#	--with-terminfo-dirs=${prefix}/share/terminfo
	#
	#	--host=${opt_host}

	local configure_options="
		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		--without-debug
		--without-profile

		--without-progs
		--without-tests

		--without-ada

		--with-cxx
		--with-cxx-binding

		${with_normal}
		${with_shared}

		--enable-exp-win32
		--enable-term-driver

		--disable-ext-colors

		--enable-sp-funcs
		--enable-interop

		--enable-overwrite
		--enable-widec
		--disable-lib-suffixes

		--enable-pc-files

		--disable-termcap
		--with-default-terminfo-dir=${_prefix}/share/terminfo

		--enable-mixed-case
		--disable-symlinks
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	PATH_SEPARATOR=';' ${_srcdir}/configure \
		-C \
		${configure_options} \
		"${with_libtool}" \
		"${with_libtool_opts}" \
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
		LIBS='-Wl,user32.lib' \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

ncurses_build() {
	_make_build CFLAGS="${cflags}" CXXFLAGS="${cxxflags}"
}

ncurses_test() {
	if ${MAKE_CHECK}; then
		note "${package}: testsuite is interactive"
		touch "${test_stamp}"

		: _make_test
	fi
}

ncurses_stage() {
	_make_stage install
}

ncurses_pack_patch() {

	# windows-style filenames are broken with DESTDIR installation

	if test -d "${destdir}${prefix}/share/terminfo"; then
		mv "${destdir}${prefix}/share/terminfo" -t share || exit
		rm -rf "${destdir}${prefix}"
	fi

	local old_pwd=$(pwd)

	# Fix whatever is going on when using installed libtool

	if ${opt_ncurses_static}; then

		# rename libNAME.a -> NAME.lib

		local lib libname
		for lib in lib/*.a; do
			libname=$(basename $lib | sed -E 's|^lib(.+)\.a$|\1.lib|')
			mv $lib lib/$libname || exit
		done

	else

		rm -f lib/lib*.lib

		# remove symbolic links

		local file
		for file in lib/*; do
			test -h $file && rm -f $file
		done

		# move shared libraries to bin

		local dll dll_basename
		for dll in lib/*.dll; do
			#dll_basename=$(printf %s $(basename $dll) | sed -E 's|(lib)?(.+).dll|\2.dll|')
			dll_basename=$(basename $dll)
			mv $dll bin/$dll_basename
		done

		# Automake's compile wrapper looks for -lNAME as follows:
		#
		# - NAME.dll.lib
		# - NAME.lib
		# - libNAME.a
		#
		# if not found, it passes plain NAME.lib
		#

		local lib lib_basename
		for lib in ${builddir}/lib/.libs/*.lib; do
			lib_basename=$(basename $lib)

			if [ -f lib/$lib_basename ] || [ -h lib/$lib_basename ]; then
				rm -f lib/$lib_basename
			fi

			# strip lib prefix so `compile` will find it during configure as
			# -lncurses, -lpanel atc.
			lib_basename=$(printf %s $lib_basename | sed -E 's|(lib)?(.+).lib|\2.lib|')

			cp ${lib} lib/$lib_basename
		done

		# patch .la files

		local la la_libname
		for la in lib/*.la; do
			la_libname=$(printf %s $(basename $la) | sed -E 's/(lib)?(.+).la/\2/')
			# escape ncurses++
			la_libname=$(printf %s $la_libname | sed 's|+|\\&|g')

			sed -i -E "/^library_names=/ s|(lib)?${la_libname}[[:digit:]-]*.dll[[:space:]]+||" $la
			sed -i -E "/^library_names=/ s|(lib)?(${la_libname}).lib|\2.dll.lib|" $la

			sed -i -E "s|lib${la_libname}(.dll)?.lib|${la_libname}\1.lib|g" $la
		done
	fi

	# replace symlinks with files they refer to

	local dir link target
	for dir in $(find $(pwd) -type d); do
		cd $dir || exit

		for link in $(find -maxdepth 1 -type l); do
			target=$(readlink $link)
			rm -f $link
			cp $target $link || exit
		done
	done

	cd $old_pwd || exit
}

ncurses_pack() {
	_make_pack ncurses_pack_patch
}

ncurses_install() {
	_make_install
}

ncurses_main() {
	_make_main ncurses "${NCURSES_SRCDIR}"
}
