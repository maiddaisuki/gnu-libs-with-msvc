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

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

	# FIXME: configure should check whether -ladvapi32 is required
	build_libs='-ladvapi32'

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
		--with-system-libdir="${prefix}/lib" \
		--with-system-includedir="${prefix}/include" \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

pkgconf_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

pkgconf_test() {
	if ${MAKE_CHECK}; then
		: _make_test
	fi
}

pkgconf_stage() {
	_make_stage
}

pkgconf_pack_hook() {
	if [ ! -f bin/${opt_host}-pkgconf.exe ]; then
		(cd bin && ln pkgconf.exe ${opt_host}-pkgconf.exe) || exit
	fi

	if [ ! -f bin/pkg-config.exe ]; then
		(cd bin && ln pkgconf.exe pkg-config.exe) || exit
		(cd bin && ln pkgconf.exe ${opt_host}-pkg-config.exe) || exit
	fi
}

pkgconf_pack() {
	local libs='pkgconf'
	_make_pack pkgconf_pack_hook
}

pkgconf_install() {
	_make_install
}

pkgconf_main() {
	_make_main pkgconf pkgconf "${PKGCONF_SRCDIR}"
}
