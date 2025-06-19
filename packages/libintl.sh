#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libintl (options as of gettext 0.25)
#
# --enable-c++
# --enable-csharp[=mono|dotnet]
# --enable-d
# --enable-java
# --enable-modula2
#
# --enable-libasprintf
# --enable-nls
#
## gnulib options
#
# --enable-cross-guesses=conservative|risky
# --enable-largefile
# --enable-relocatable
# --enable-year2038
# --enable-threads=isoc|posix|isoc+posix|windows
#
# --with-gnulib-prefix=DIR
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
#
# --with-included-gettext
#
## Developer options
#
# --enable-more-warnings
#

libintl_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--disable-libasprintf

		--enable-c++
		--disable-csharp
		--disable-d
		--disable-java
		--disable-modula2

		--enable-nls
		--enable-threads=windows
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/gettext-runtime/configure \
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

libintl_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libintl_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libintl_stage() {
	_make_stage
}

libintl_pack() {
	_make_pack
}

libintl_install() {
	_make_install
}

libintl_main() {
	_make_main libintl "${GETTEXT_SRCDIR}" gettext/gettext-runtime
}
