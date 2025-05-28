#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build bzip2 (options as of 1.0.8)
#
# No options
#

bzip2_configure() {
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
