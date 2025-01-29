#!/bin/env sh

# Build libintl

## configure options for libintl as of gettext 0.23
#
# --enable-cross-guesses=conservative|risky
# --enable-relocatable
#
# --disable-largefile
# --enable-year2038
#
# --disable-c++
# --enable-csharp[=mono|dotnet]
# --disable-java
#
# --disable-nls
# --enable-threads=isoc|posix|isoc+posix|windows
#
# --disable-libasprintf
#
# --with-libiconv-prefix[=DIR]
# --without-libiconv-prefix
#
# --with-included-gettext
# --with-libintl-prefix[=DIR]
# --without-libintl-prefix
#
# --enable-more-warnings
#

libintl_configure() {
	print "${package}: configuring"

	local enable_threads=windows

	if [ ${stage} = 2 ]; then
		if ${WITH_WINPTHREADS}; then
			enable_threads=posix
			local cppflags="${cppflags} -FIpthread_compat.h"
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

		--disable-libasprintf

		--enable-c++
		--disable-csharp
		--disable-java

		--enable-nls
		--enable-threads=${enable_threads}
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/gettext-runtime/configure \
		-C \
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

	test $? -eq 0 || die "${package}: configure failed"
}

libintl_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libintl_test() {
	if ${MAKE_CHECK}; then
		_make_test -i check
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
	_make_main libintl "${GETTEXT_SRCDIR}" gettext-runtime
}
