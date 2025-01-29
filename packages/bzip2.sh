#!/bin/env sh

# Build bzip2

## Meson options as of bzip2 1.0.8
#
# (no options)
#

bzip2_configure() {
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

bzip2_build() {
	_meson_build
}

bzip2_test() {
	if ${ENABLE_TESTS}; then
		_meson_test
	fi
}

bzip2_stage() {
	_meson_stage
}

bzip2_pack() {
	_meson_pack
}

bzip2_install() {
	_meson_install
}

bzip2_main() {
	_meson_main bzip2 "${BZIP2_SRCDIR}"
}
