#!/bin/sh

##
# The post_install function
#
# Run install-info to make info manuals in PREFIX/share/info usable.
#
post_install() {
	test -d ${u_prefix} || return

	local i

	if test -d "${u_prefix}/share/info"; then
		if type install-info >/dev/null 2>&1; then
			for i in $(find "${u_prefix}/share/info" -name '*.info'); do
				install-info $i ${u_prefix}/share/info/dir
			done
		fi
	fi
}
