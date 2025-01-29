#!/bin/env sh

# Build winpthreads (Meson)

## Meson options as of winpthreads 1.0
#
# (no options)
#

winpthreads_configure() {
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

winpthreads_build() {
	_meson_build
}

winpthreads_test() {
	if ${ENABLE_TESTS}; then
		_meson_test
	fi
}

winpthreads_stage() {
	_meson_stage
}

winpthreads_pack() {
	_meson_pack
}

winpthreads_install() {
	_meson_install
}

winpthreads_main() {
	_meson_main winpthreads "${WINPTHREADS_SRCDIR}"
}
