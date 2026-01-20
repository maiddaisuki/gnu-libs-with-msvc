#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libpsl (options as of version 0.21.5)
#
# --enable-nls
#
# --enable-largefile
# --enable-year2038
#
# --enable-cfi
#
## Dependencies
#
# --enable-runtime={libidn|libicu|libidn2}
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libunistring-prefix[=DIR]
#
## Installation
#
# --enable-builtin
#
# --with-psl-file=PATH
# --with-psl-distfile=PATH
# --with-psl-testfile=PATH
#
# --with-python_prefix
# --with-python-sys-prefix
# --with-python_exec_prefix
#
# --enable-man
#
## Developer Options
#
# --enable-valgrind-tests
#
# --enable-asan
# --enable-ubsan
#
# --enable-fuzzing
#

libpsl_configure() {
	print "${package}: configuring"

	# Whether to use libidn[2]+libunistring or libicu
	local runtime=

	if ${WITH_LIBIDN2} && ${WITH_LIBUNISTRING}; then
		runtime=libidn2

		local libidn2_cflags=
		local libidn2_libs=

		if ${build_shared}; then
			libidn2_cflags=$(${PKG_CONFIG} --cflags libidn2)
			libidn2_libs=$(${PKG_CONFIG} --libs libidn2)
		else
			libidn2_cflags=$(${PKG_CONFIG} --static --cflags libidn2)
			libidn2_libs=$(${PKG_CONFIG} --static --libs libidn2)
		fi

		build_cppflags="${build_cppflags} ${libidn2_cflags}"
		build_libs="${build_libs} ${libidn2_libs}"
	elif ${WITH_LIBIDN} && ${WITH_LIBUNISTRING}; then
		runtime=libidn
	else
		runtime=libicu
	fi

	if ! ${build_shared}; then
		build_cppflags="${build_cppflags} -DPSL_STATIC"

		# FIXME: required to link against static libintl
		if ${WITH_LIBINTL}; then
			build_libs="${build_libs} -ladvapi32"
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

		--enable-nls
		--enable-runtime=${runtime}
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

libpsl_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

libpsl_test() {
	if ${MAKE_CHECK}; then
		# FIXME: this should be fixed in upstream
		_make_test check CPPFLAGS="-I\$(top_builddir)/include ${cppflags} ${build_cppflags}"
	fi
}

libpsl_stage() {
	_make_stage
}

libpsl_pack_hook() {
	local filename=

	if [ -d lib/pkgconfig ] && [ -f lib/pkgconfig/libpsl.pc ]; then
		filename=lib/pkgconfig/libpsl.pc
	elif [ -d share/pkgconfig ] && [ -f share/pkgconfig/libpsl.pc ]; then
		filename=share/pkgconfig/libpsl.pc
	fi

	if [ -n "${filename}" ]; then
		if ! grep '^Cflags\.private' ${filename} >/dev/null 2>&1; then
			printf "%s\n" 'Cflags.private: -DPSL_STATIC' >>${filename}
		fi
	fi
}

libpsl_pack() {
	local libs='psl'
	_make_pack libpsl_pack_hook
}

libpsl_install() {
	_make_install
}

libpsl_main() {
	_make_main libpsl libpsl "${LIBPSL_SRCDIR}"
}
