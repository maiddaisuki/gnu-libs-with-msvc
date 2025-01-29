#!/bin/env sh

# Build readline

## configure options as of readline 8.2
#
# --disable-largefile
# --disable-bracketed-paste-default
#
# --disable-install-examples
#
# --with-curses
# --with-shared-termcap-library
#

readline_configure() {
	print "${package}: configuring"

	local with_termcap=--without-shared-termcap-library

	#if ${opt_static}; then :; else
	#	if ${ENABLE_STATIC}; then :; else
	#		with_termcap=--with-shared-termcap-library
	#	fi
	#fi

	#	${enable_shared}
	#	${enable_static}

	#	--disable-shared
	#	--enable-static

	local configure_options="
		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		--with-curses
		${with_termcap}
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
		>>"${configure_log}" 2>&1

	test $? -eq 0 || die "${package}: configure failed"
}

readline_build() {
	_make_build CFLAGS="${cflags}" CXXFLAGS="${cxxflags}"
}

readline_test() {
	if ${MAKE_CHECK}; then
		note "${package}: no testsuite to run"
		touch "${test_stamp}"

		: _make_test
	fi
}

readline_stage() {
	: _make_stage install
}

readline_pack() {
	: _make_pack
}

readline_install() {
	: _make_install
}

readline_main() {
	_make_main readline "${READLINE_SRCDIR}"
}
