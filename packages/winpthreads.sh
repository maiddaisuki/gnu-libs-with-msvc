#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build winpthreads (options as of 1.0)
#
# No options
#

winpthreads_configure() {
	print "${package}: configuring"

	local c_args=$(meson_args ${CPPFLAGS} ${CFLAGS})
	local cpp_args=$(meson_args ${CPPFLAGS} ${CXXFLAGS})
	local link_args=$(meson_args ${LDFLAGS})

	local options="
		--buildtype plain
		--default-library ${default_library}

		--prefix ${prefix}
		--libdir lib

		-Db_vscrt=${vscrt}
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
