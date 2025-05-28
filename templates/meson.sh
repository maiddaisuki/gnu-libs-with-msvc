#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build PACKAGE (options as of VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
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

PACKAGE_build() {
	_meson_build
}

PACKAGE_test() {
	if ${ENABLE_TESTS}; then
		_meson_test
	fi
}

PACKAGE_stage() {
	_meson_stage
}

PACKAGE_pack() {
	_meson_pack
}

PACKAGE_install() {
	_meson_install
}

PACKAGE_main() {
	_meson_main PACKAGE "${package_SRCDIR}"
}
