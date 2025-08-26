#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build pkgconf (options as of 2.5.1)
#
# --enable-largefile
# --enable-year2038
#
# --with-personality-dir
# --with-pkg-config-dir
#
# --with-system-libdir
# --with-system-includedir
#

pkgconf_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}
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
		LIBS=-ladvapi32 \
		${configure_options} \
		--with-system-libdir="${prefix}/lib" \
		--with-system-includedir="${prefix}/include" \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

pkgconf_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

pkgconf_test() {
	if ${MAKE_CHECK}; then
		: _make_test
	fi
}

pkgconf_stage() {
	_make_stage
}

pkgconf_pack() {
	_make_pack
}

pkgconf_install() {
	_make_install
}

pkgconf_main() {
	_make_main pkgconf "${PKGCONF_SRCDIR}"
}
