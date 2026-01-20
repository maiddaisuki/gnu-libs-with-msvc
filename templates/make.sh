#!/bin/sh

# BUILD_SYSTEM: BUILD SYSTEM

##
# Build PACKAGE_NAME (options as of VERSION)
#
# List package-specific options, if any
#

PACKAGE_configure() {
	print "${package}: configuring"

	# You can set the following variables:
	#
	# build_cppflags=
	# build_cflags=
	# build_cxxflags=
	# build_ldflags=
	# build_libs=
	#
	# They allow to pass extra compiler/linker flags for a specific package.
	#
	# Note that this is intended as a mean to handle some build options in a
	# package-specific way or work around some issues.

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
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags} -Oi-" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags} -Oi-" \
		AS="${as}" \
		LD="${ld}" \
		LDFLAGS="${ldflags} ${build_ldflags}" \
		LIBS="${build_libs}" \
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
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

PACKAGE_test() {
	# By default, _make_test runs `check` target:
	#
	#	make -k check
	#
	# Some packages may have different name, such as `test`. You can pass
	# name of the target to run as an argument:
	#
	#	`_make_test test` will run `make -k test`
	#
	# This also allows to pass options to make, but in this case you will also
	# need to pass name of the target to run:
	#
	#	`_make_test -i check` will run `make -k -i check`
	#
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

PACKAGE_stage() {
	# If package supports DESTDIR mechanism, but uses different variable name,
	# set this variable to that variable's name.
	#local destdir_var=
	# By default, _make_stage runs `install-strip` target:
	#
	#	make DESTDIR=... install-strip
	#
	# Some packages which do not use Automake may not support `install-strip`
	# target. You can pass name of the target to run as an argument:
	#
	#	`_make_stage install` will run `make DESTDIR=... install`
	#
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
