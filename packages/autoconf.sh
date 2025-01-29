#!/bin/env sh

# Build autoconf

## configure options as of autoconf 2.72
#
# --with-lispdir
#
## Variables
#
# M4
#
# EMACS
# EMACSLOADPATH
#

autoconf_configure() {
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

autoconf_build() {
	_make_build
}

autoconf_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

autoconf_stage() {
	_make_stage
}

autoconf_pack() {
	_make_pack
}

autoconf_install() {
	_make_install
}

autoconf_main() {
	_make_main autoconf "${AUTOCONF_SRCDIR}"
}
