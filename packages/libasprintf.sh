#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libasprintf (options as of gettext 0.25)
#
## gnulib options
#
# --enable-cross-guesses={conservative|risky}
#
## Developer options
#
# --enable-more-warnings
#

libasprintf_configure() {
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

	${_srcdir}/gettext-runtime/libasprintf/configure \
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

libasprintf_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

libasprintf_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

libasprintf_stage() {
	_make_stage
}

libasprintf_pack() {
	_make_pack
}

libasprintf_install() {
	_make_install
}

libasprintf_main() {
	_make_main libasprintf "${GETTEXT_SRCDIR}" gettext/gettext-runtime/libasprintf
}
