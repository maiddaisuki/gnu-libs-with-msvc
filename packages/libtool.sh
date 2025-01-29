#!/bin/env sh

# Build libtool

## configure options as of libtool 2.5.4
#
#  --enable-cross-guesses=conservative|risky
#
#  --disable-ltdl-install
#  --enable-ltdl-install
#

libtool_configure() {
	print "${package}: configuring"

	local enable_ltld=--disable-ltdl-install

	if [ ${stage} = 3 ]; then
		enable_ltld=--enable-ltdl-install
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		${enable_ltld}
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

libtool_build() {
	_make_build CFLAGS="${cflags}" CXXFLAGS="${cxxflags}"
}

libtool_test() {
	if ${MAKE_CHECK}; then
		_make_test -i check
	fi
}

libtool_stage() {
	_make_stage
}

libtool_pack() {
	_make_pack
}

libtool_install() {
	_make_install
}

libtool_main() {
	_make_main libtool "${LIBTOOL_SRCDIR}"
}
