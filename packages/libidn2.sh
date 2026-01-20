#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libidn2 (options as of version 2.3.8)
#
# --enable-nls
#
## gnulib
#
# --enable-cross-guesses={conservative|risky}
# --enable-largefile
# --enable-year2038
#
# --with-gnulib-prefix=DIR
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libunistring-prefix[=DIR]
#
# --with-included-libunistring
#
## Installation
#
# --enable-doc
# --with-html-dir=PATH
#
# --enable-gtk-doc
# --enable-gtk-doc-html
# --enable-gtk-doc-pdf
#
# --with-packager
# --with-packager-version
# --with-packager-bug-reports
#
## Developer Options
#
# --enable-gcc-warnings[={no|yes|expensive|error}]
#
# --enable-code-coverage
# --with-gcov=filename
#
# --enable-valgrind-tests
#

libidn2_configure() {
	print "${package}: configuring"

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	if ! ${build_shared}; then
		build_cppflags="${build_cppflags} -DIDN2_STATIC"

		# FIXME: required to link against static libintl
		if ${WITH_LIBINTL}; then
			build_libs='-ladvapi32'
		fi
	fi

	# Dependencies
	local with_libunistring=--with-included-libunistring

	if ${WITH_LIBUNISTRING}; then
		with_libunistring=--without-included-libunistring
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-nls
		--disable-gcc-warnings

		${with_libunistring}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
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

libidn2_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

libidn2_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libidn2_stage() {
	_make_stage
}

libidn2_pack_hook() {
	local filename=

	if [ -d lib/pkgconfig ] && [ -f lib/pkgconfig/libidn2.pc ]; then
		filename=lib/pkgconfig/libidn2.pc
	elif [ -d share/pkgconfig ] && [ -f share/pkgconfig/libidn2.pc ]; then
		filename=share/pkgconfig/libidn2.pc
	fi

	if [ -n "${filename}" ]; then
		if ! grep '^Cflags\.private' ${filename} >/dev/null 2>&1; then
			printf "%s\n" 'Cflags.private: -DIDN2_STATIC' >>${filename}
		fi
	fi
}

libidn2_pack() {
	local libs='idn2'
	_make_pack libidn2_pack_hook
}

libidn2_install() {
	_make_install
}

libidn2_main() {
	_make_main libidn2 libidn2 "${LIBIDN2_SRCDIR}"
}
