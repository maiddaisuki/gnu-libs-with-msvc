#!/bin/sh

# BUILD_SYSTEM: meson

##
# Build PACKAGE_NAME (options as of VERSION)
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
	# This variable should contain space-separated list of libraries
	# installed by this packages.
	#
	# This list may contain libraries which may not be installed,
	# for example, if their installation is optional.
	#
	# If package installs libfoo and libbar, this list may contain 'foo bar'.
	# If package does not install any libraries, leave this list empty.
	#
	# If default _meson_pack_rename_libs function is unable to correctly rename
	# package's libraries, you may need to write custom PACKAGE_pack_hook
	# function. In this case, leave this list empty.
	local libs=''
	_meson_pack
}

PACKAGE_install() {
	_meson_install
}

PACKAGE_main() {
	_meson_main PACKAGE_NAME PACKAGE "${package_SRCDIR}"
}
