#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build winpthreads (options as of 1.0)
#
# No options
#

winpthreads_configure() {
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

winpthreads_build() {
	_make_build "CFLAGS=${cflags}" "CXXFLAGS=${cxxflags}"
}

winpthreads_test() {
	if ${MAKE_CHECK}; then
		_make_test
	fi
}

winpthreads_stage() {
	_make_stage
}

winpthreads_pack_hook() {
	# make libtool happy
	local dll link

	for dll in $(dir bin); do
		case ${dll} in
		*winpthread*.dll)
			link=$(printf %s ${dll} | sed 's|winpthread|pthread|')
			(cd bin && ln ${dll} ${link}) || exit
			;;
		esac
	done
}

winpthreads_pack() {
	local libs='pthread winpthread'
	_make_pack winpthreads_pack_hook
}

winpthreads_install() {
	_make_install
}

winpthreads_main() {
	_make_main winpthreads winpthreads "${WINPTHREADS_SRCDIR}"
}
