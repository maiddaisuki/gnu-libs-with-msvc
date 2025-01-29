#!/bin/env sh

# Build automake

## configure options as of automake 2.72
#
## Variables
#
# AM_TEST_RUNNER_SHELL
#
# FC
# FCFLAGS
#
# F77
# FFLAGS
#
# GNU_CC
# GNU_CFLAGS
#
# GNU_CXX
# GNU_CXXFLAGS
#
# GNU_FC
# GNU_FCFLAGS
#
# GNU_F77
# GNU_FFLAGS
#
# GNU_GCJ
# GNU_GCJFLAGS

automake_configure() {
	print "${package}: configuring"

	local configure_options="
		--disable-silent-rules

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib
	"

	if [ -f Makefile ]; then
		find "${logdir}" -type f -exec rm -f \{\} +
		make distclean >/dev/null 2>&1
	fi

	${_srcdir}/configure \
		-C \
		${configure_options} \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags}" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags}" \
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
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

automake_build() {
	_make_build
}

automake_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

automake_stage() {
	_make_stage
}

automake_pack() {
	_make_pack
}

automake_install() {
	_make_install
}

automake_main() {
	_make_main automake "${AUTOMAKE_SRCDIR}"
}
