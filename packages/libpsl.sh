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

	local local_cppflags=
	local local_libs=

	# Whether to use libidn[2]+libunistring or libicu
	local runtime=

	if ${WITH_LIBIDN2} && ${WITH_LIBUNISTRING}; then
		runtime=libidn2

		if ${build_shared}; then
			local_cppflags=$(${PKG_CONFIG} --cflags libidn2)
			local_libs=$(${PKG_CONFIG} --libs libidn2)
		else
			local_cppflags=$(${PKG_CONFIG} --static --cflags libidn2)
			local_libs=$(${PKG_CONFIG} --static --libs libidn2)
		fi
	elif ${WITH_LIBIDN} && ${WITH_LIBUNISTRING}; then
		runtime=libidn
	else
		runtime=libicu
	fi

	if ! ${build_shared}; then
		local_cppflags="${local_cppflags} -DPSL_STATIC"

		# FIXME: required to link against static libintl
		if ${WITH_LIBINTL}; then
			local_libs="${local_libs} -ladvapi32"
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
		CPPFLAGS="${cppflags} ${local_cppflags}" \
		CFLAGS="${cflags} -Oi-" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} -Oi-" \
		AS="${as}" \
		LD="${ld}" \
		LDFLAGS="${ldflags}" \
		LIBS="${local_libs}" \
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
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libpsl_test() {
	if ${MAKE_CHECK}; then
		# FIXME: this should be fixed in upstream
		_make_test check CPPFLAGS="-I\$(top_builddir)/include ${cppflags}"
	fi
}

libpsl_stage() {
	_make_stage
}

libpsl_pack_hock() {
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
	_make_pack libpsl_pack_hock
}

libpsl_install() {
	_make_install
}

libpsl_main() {
	_make_main libpsl libpsl "${LIBPSL_SRCDIR}"
}
