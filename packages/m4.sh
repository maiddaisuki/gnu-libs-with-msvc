#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build m4 (options as of version 1.4.20)
#
# --with-packager
# --with-packager-version
# --with-packager-bug-reports
#
# --enable-cross-guesses=conservative|risky
#
# --disable-largefile
# --disable-year2038
# --enable-threads=isoc|posix|isoc+posix|windows
#
# --enable-c++
# --enable-changeword
#
# --disable-nls
#
# --with-syscmd-shell=FILENAME
#
## Dependencies
#
# --without-included-regex
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --with-libsigsegv
# --with-libsigsegv-prefix[=DIR]
# --without-libsigsegv-prefix
#
# --with-gnulib-prefix=DIR
#
# --with-dmalloc
#
## Developer options
#
# --enable-gcc-warnings
# --disable-assert
#

m4_configure() {
	print "${package}: configuring"

	# Optional dependencies
	local with_libsigsegv=--without-libsigsegv

	if ${WITH_LIBSIGSEGV}; then
		with_libsigsegv=--with-libsigsegv
	fi

	# Features
	local enable_assert=--disable-assert
	local enable_threads=windows
	local libs=

	if [ ${opt_buildtype} = debug ]; then
		enable_assert=--enable-assert
	fi

	if ${WITH_WINPTHREADS}; then
		enable_threads=posix
		libs=-lpthread
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_assert}
		--enable-nls
		--enable-threads=${enable_threads}

		--with-syscmd-shell=$(cygpath -m $(which cmd.exe))
		${with_libsigsegv}
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
		LIBS="${libs}" \
		${configure_options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

m4_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

m4_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

m4_stage() {
	_make_stage
}

m4_pack() {
	_make_pack
}

m4_install() {
	_make_install
}

m4_main() {
	_make_main m4 "${M4_SRCDIR}"
}
