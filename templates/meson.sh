#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build PACKAGE (options as of VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
	print "${package}: configuring"

	local options="
		--buildtype ${buildtype}
		--default-library ${default_library}

		--prefix ${prefix}
		--libdir lib

		-Db_vscrt=${vscrt}
	"

	meson setup "${srcdir}" --vsenv --wipe \
		-Dc_args="${CPPFLAGS} ${CFLAGS}" \
		-Dc_link_args="${LDFLAGS}" \
		-Dcpp_args="${CPPFLAGS} ${CXXFLAGS}" \
		-Dcpp_link_args="${LDFLAGS}" \
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
