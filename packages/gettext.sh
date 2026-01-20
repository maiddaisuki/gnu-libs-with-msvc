#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build gettext-tools (options as of gettext 0.26)
#
# --enable-c++
# --enable-csharp[=dotnet|mono]
# --enable-d
# --enable-go
# --enable-java
# --enable-modula2
#
# --enable-libasprintf
# --enable-namespacing
# --enable-nls
#
# --enable-acl
# --enable-openmp
#
# [not for Windows]
#
# --enable-xattr
#
## gnulib options
#
# --enable-cross-guesses=conservative|risky
# --enable-largefile
# --enable-relocatable
# --enable-threads=isoc|posix|isoc+posix|windows
# --enable-year2038
#
# --with-gnulib-prefix=DIR
#
## Dependencies
#
# --with-libsmack
#
# --with-installed-csharp-dll
# --with-installed-libtextstyle
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libtextstyle-prefix[=DIR]
# --with-libunistring-prefix[=DIR]
# --with-libxml2-prefix[=DIR]
#
# --with-included-gettext
# --with-included-libunistring
# --with-included-libxml
# --with-included-regex
#
# [not for Windows]
#
# --with-selinux
#
## Installation
#
# --with-emacs
# --with-lispdir
#
# --with-git
# --with-cvs
# --with-bzip2
# --with-xz
#
# --with-bison-prefix=DIR
#
## Developer options
#
# --enable-more-warnings
#

gettext_configure() {
	print "${package}: configuring"

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	# Dependencies
	local with_libunistring=--with-included-libunistring
	local with_libxml2=--with-included-libxml

	if ${WITH_LIBUNISTRING}; then
		with_libunistring=--without-included-libunistring
	fi

	if ${WITH_LIBXML2}; then
		with_libxml2=--without-included-libxml

		local libxml2_cflags=
		local libxml2_ldflags=

		if ${build_shared}; then
			libxml2_cflags=$(${PKG_CONFIG} --cflags libxml-2.0)
			libxml2_ldflags=$(${PKG_CONFIG} --libs libxml-2.0)
		else
			libxml2_cflags=$(${PKG_CONFIG} --static --cflags libxml-2.0)
			libxml2_ldflags=$(${PKG_CONFIG} --static --libs libxml-2.0)
		fi

		build_cppflags="${build_cppflags} ${libxml2_cflags}"
		build_libs="${build_libs} ${libxml2_ldflags}"
	fi

	# Features
	local enable_libasprintf=--disable-libasprintf
	local enable_threads=windows
	local enable_warnings=--disable-more-warnings

	if ${WITH_LIBASPRINTF}; then
		enable_libasprintf=--enable-libasprintf
	fi

	if ${opt_posix_threads}; then
		enable_threads=posix
	fi

	if [ ${opt_toolchain} = llvm ]; then
		enable_warnings=--enable-more-warnings
	fi

	# TODO
	local with_emacs=--without-emacs

	if ${WITH_EMACS}; then
		with_emacs=--with-emacs
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		${enable_libasprintf}

		--enable-c++
		--disable-csharp
		--disable-d
		--disable-java
		--disable-modula2

		--enable-nls
		--enable-threads=${enable_threads}
		${enable_warnings}

		${with_emacs}
		${with_libunistring}
		${with_libxml2}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	#	YACC="$(cygpath -m "${PREFIX}/bin/bison.exe") -y" \

	${_srcdir}/gettext-tools/configure \
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

	test $? -eq 0 || die "${package}: configuration failed"
}

gettext_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

gettext_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

gettext_stage() {
	_make_stage
}

gettext_pack() {
	local libs='gettextlib gettextpo gettextsrc'
	_make_pack
}

gettext_install() {
	_make_install
}

gettext_main() {
	_make_main gettext gettext "${GETTEXT_SRCDIR}" gettext/gettext-tools
}
