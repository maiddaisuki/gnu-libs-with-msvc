#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build libtool (options as of version 2.5.4)
#
#  --enable-cross-guesses=conservative|risky
#
#  --disable-ltdl-install
#  --enable-ltdl-install
#

libtool_configure() {
	print "${package}: configuring"

	# Features
	local enable_ltdl=--disable-ltdl-install

	if [ ${stage} = 3 ]; then
		enable_ltdl=--enable-ltdl-install
	fi

	local configure_options="
		--disable-silent-rules
		--disable-dependency-tracking

		--host=${opt_host}

		--prefix=${_prefix}
		--libdir=${_prefix}/lib

		${enable_shared}
		${enable_static}

		${enable_ltdl}
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
		F77=no \
		FC=no \
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

libtool_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
}

libtool_test() {
	if [ ${stage} -eq 3 ] && ${MAKE_CHECK}; then
		_make_test
	fi
}

libtool_stage() {
	_make_stage
}

libtool_pack() {
	local libs='ltdl'
	_make_pack
}

libtool_install() {
	_make_install
}

libtool_main() {
	_make_main libtool libtool "${LIBTOOL_SRCDIR}"
}
