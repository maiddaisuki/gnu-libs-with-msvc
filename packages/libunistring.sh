#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libunistring (options as of version 1.3)
#
# --enable-namespacing
#
## gnulib options
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
# --enable-largefile
# --enable-threads=isoc|posix|isoc+posix|windows
# --enable-year2038
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
#

libunistring_configure() {
	print "${package}: configuring"

	# Features
	local enable_threads=windows

	if [ ${stage} = 2 ]; then
		if ${WITH_WINPTHREADS}; then
			enable_threads=posix
		fi
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-threads=${enable_threads}
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
		${configure_options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

libunistring_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libunistring_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libunistring_stage() {
	_make_stage
}

libunistring_pack() {
	_make_pack
}

libunistring_install() {
	_make_install
}

libunistring_main() {
	_make_main libunistring "${LIBUNISTRING_SRCDIR}"
}
