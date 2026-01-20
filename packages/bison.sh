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

	if ! ${build_shared}; then
		# FIXME: required to link against static libintl
		if ${WITH_LIBINTL}; then
			build_libs='-ladvapi32'
		fi
	fi

	# Features
	local enable_assert=--disable-assert
	local enable_warnings=--disable-gcc-warnings

	if ${opt_assert}; then
		enable_assert=--enable-assert
	fi

	if [ ${opt_toolchain} = llvm ]; then
		enable_warnings=--enable-gcc-warnings
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
		--enable-threads=windows
		${enable_warnings}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		M4="$(cygpath -m "${PREFIX}/bin/m4.exe")" \
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
	# Fix for out-of-tree build
	test -d examples || cp -Rp ${_srcdir}/examples -t . || exit
}

bison_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
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
	local libs=''
	_make_pack
}

bison_install() {
	_make_install
}

bison_main() {
	_make_main bison bison "${BISON_SRCDIR}"
}
