#!/bin/sh

# BUILD_SYSTEM: autotools (automake + libtool)

##
# Build winpthreads (options as of 1.0)
#
# No options
#

winpthreads_configure() {
	print "${package}: configuring"

	if ! ${opt_assert}; then
		build_cppflags='-DNDEBUG'
	fi

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

winpthreads_build() {
	_make_build \
		CPPFLAGS="${cppflags} ${build_cppflags}" \
		CFLAGS="${cflags} ${build_cflags}" \
		CXXFLAGS="${cxxflags} ${build_cxxflags}"
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

	if [ -d bin ]; then
		for dll in $(ls bin | grep 'dll$'); do
			if case ${dll} in *winpthread*.dll) true ;; *) false ;; esac then
				link=$(printf %s ${dll} | sed 's|winpthread|pthread|')

				if [ ! -f ${link} ]; then
					(cd bin && ln ${dll} ${link}) || exit
				fi
			fi
		done
	fi

	# install winpthreads.pc
	test -d lib/pkgconfig || install -d lib/pkgconfig || exit

	if [ ! -f lib/pkgconfig/winpthreads.pc ]; then
		cat <<-EOF >lib/pkgconfig/winpthreads.pc
			prefix=${prefix}
			includedir=\${prefix}/include
			libdir=\${prefix}/lib

			Name: winpthreads
			Description: The Winpthreads Library
			Version: 1.0
			URL: https://www.mingw-w64.org/

			Cflags: -I\${includedir} -DWINPTHREADS_USE_DLLIMPORT
			Cflags.private: -UWINPTHREADS_USE_DLLIMPORT
			Libs: -L\${libdir} -lpthread
			Libs.private:
		EOF
	fi
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
