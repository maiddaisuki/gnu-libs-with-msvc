#!/bin/env sh

# Build PACKAGE

## Meson options as of PACKAGE VERSION
#
# (list options here)
#

PACKAGE_configure() {
	print "${package}: configuring"

	local options="
	"

	meson setup "${srcdir}" --vsenv --wipe \
		${options} \
		--prefix "${prefix}" \
		--libdir lib \
		--buildtype ${buildtype} \
		--default-library ${default_library} \
		-Db_vscrt=${vscrt} \
		-Dc_args="${CPPFLAGS} ${CFLAGS}" \
		-Dcpp_args="${CPPFLAGS} ${CXXFLAGS}" \
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
