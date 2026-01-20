#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build tre (options as of version 0.9.0)
#
# --enable-nls
#
# --enable-largefile
# --enable-year2038
#
# --enable-approx
# --enable-agrep
# --enable-wchar
# --enable-multibyte
#
# --enable-system-abi
#
# --with-alloca
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libutf8[=DIR]
#
## Developer Options
#
# --enable-warnings
#
# --enable-profile
# --enable-debug
#

libtre_configure() {
	print "${package}: configuring"

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	if ! ${build_shared}; then
		# FIXME: required to link against static libintl
		if ${WITH_LIBINTL}; then
			build_libs='-ladvapi32'
		fi
	fi

	# Features
	local enable_warnings=--disable-warnings

	if [ ${opt_toolchain} = llvm ]; then
		enable_warnings=--enable-warnings
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${host_opt}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		--enable-nls
		--disable-agrep
		${enable_warnings}

		--without-alloca
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

libtre_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

libtre_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libtre_stage() {
	_make_stage
}

libtre_pack() {
	local libs='tre'
	_make_pack
}

libtre_install() {
	_make_install
}

libtre_main() {
	_make_main libtre libtre "${LIBTRE_SRCDIR}"
}
