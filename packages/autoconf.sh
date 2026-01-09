#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build autoconf (options as of version 2.72)
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

	# Maybe one day we will have a native POSIX shell for Windows
	local emacs=false         # TODO
	local m4=/usr/bin/m4      #$(cygpath -m "${_prefix}/bin/m4.exe")
	local perl=/usr/bin/perl  #$(cygpath -m "$(which perl.exe)")
	local shell=/usr/bin/bash #$(cygpath -m "$(which bash.exe)")

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
		EMACS="${emacs}" \
		M4="${m4}" \
		PERL="${perl}" \
		SHELL="${shell}" \
		${configure_options} \
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
	local libs=''
	_make_pack
}

autoconf_install() {
	_make_install
}

autoconf_main() {
	_make_main autoconf "${AUTOCONF_SRCDIR}"
}
