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

	# Dependencies
	local with_libunistring=--with-included-libunistring
	local with_libxml2=--with-included-libxml
	local libxml2_cflags=
	local libxml2_ldflags=

	if ${WITH_LIBUNISTRING}; then
		with_libunistring=--without-included-libunistring
	fi

	if ${WITH_LIBXML2}; then
		with_libxml2=--without-included-libxml

		if ${build_shared}; then
			libxml2_cflags=$(${PKG_CONFIG} --cflags libxml-2.0)
			libxml2_ldflags=$(${PKG_CONFIG} --libs libxml-2.0)
		else
			libxml2_cflags=$(${PKG_CONFIG} --static --cflags libxml-2.0)
			libxml2_ldflags=$(${PKG_CONFIG} --static --libs libxml-2.0)
		fi
	fi

	# Features
	local enable_libasprintf=--disable-libasprintf

	if ${WITH_LIBASPRINTF}; then
		enable_libasprintf=--enable-libasprintf
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
		--enable-threads=windows

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
		CPPFLAGS="${cppflags} ${libxml2_cflags}" \
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
		LIBS="${libxml2_ldflags}" \
		${configure_options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

gettext_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
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
	_make_pack
}

gettext_install() {
	_make_install
}

gettext_main() {
	_make_main gettext "${GETTEXT_SRCDIR}" gettext/gettext-tools
}
