#!/bin/sh

# BUILD_SYSTEM: BUILD SYSTEM

##
# Build PACKAGE_NAME (options as of VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
	print "${package}: configuring"

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
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags} -Oi-" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} -Oi-" \
		AS="${as}" \
		LD="${ld}" \
		LDFLAGS="${ldflags}" \
		AR="${ar}" \
		RANLIB="${ranlib}" \
		NM="${nm}" \
		OBJDUMP="${objdump}" \
		OBJCOPY="${objcopy}" \
		STRIP="${strip}" \
		DLLTOOL="${dlltool}" \
		${configure_options} \
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

PACKAGE_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

PACKAGE_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

PACKAGE_stage() {
	_make_stage
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
	# If default _make_pack_rename_libs function is unable to correctly rename
	# package's libraries, you may need to write custom PACKAGE_pack_hook
	# function. In this case, leave this list empty.
	local libs=''
	_make_pack
}

PACKAGE_install() {
	_make_install
}

PACKAGE_main() {
	# An optional fourth argument is name of build directory to use instead of
	# PACKAGE. This may include subdirectories to construct relative names.
	#
	# This may be useful if package contains multiple subdirectories which
	# can be configured on their own. An example of such package is gettext.
	_make_main PACKAGE_NAME PACKAGE "${package_SRCDIR}"
}
