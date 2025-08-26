#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build pkgconf (options as of 2.5.1)
#
# --with-system-includedir=STRING
# --with-system-libdir=STRING
#
# --tests=true|false
#

pkgconf_configure() {
	print "${package}: configuring"

	local c_args=$(meson_args ${build_cppflags} ${build_cflags} ${CPPFLAGS} ${CFLAGS})
	local cpp_args=$(meson_args ${build_cppflags} ${build_cxxflags} ${CPPFLAGS} ${CXXFLAGS})
	local link_args=$(meson_args ${build_ldflags} ${LDFLAGS})

	local options="
		--buildtype plain
		--default-library ${default_library}

		--prefix ${prefix}
		--libdir lib

		-Db_vscrt=${b_vscrt}
		-Db_ndebug=${b_ndebug}
	"

	meson setup "${srcdir}" --vsenv --wipe \
		-Dc_args="${c_args}" \
		-Dc_link_args="${link_args}" \
		-Dcpp_args="${cpp_args}" \
		-Dcpp_link_args="${link_args}" \
		${options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

pkgconf_build() {
	_meson_build
}

pkgconf_test() {
	if ${ENABLE_TESTS}; then
		_meson_test
	fi
}

pkgconf_stage() {
	_meson_stage
}

pkgconf_pack_hook() {
	# make libtool happy

	if [ -f lib/pkgconf.lib ]; then
		(cd lib && mv pkgconf.lib pkgconf.dll.lib) || exit
	fi

	if [ -f lib/pkgconf.a ]; then
		(cd lib && ln pkgconf.a pkgconf.lib) || exit
	fi
}

pkgconf_pack() {
	_meson_pack pkgconf_pack_hook
}

pkgconf_install() {
	_meson_install
}

pkgconf_main() {
	_meson_main pkgconf "${PKGCONF_SRCDIR}"
}
