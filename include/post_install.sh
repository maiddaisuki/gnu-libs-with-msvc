#!/bin/env sh

# The post_install function

# $1: prefix (windows-style)
# $2: prefix (unix_style)
#
post_install() {
	local w_prefix=$1
	local u_prefix=$2

	local la pc i

	test -d ${u_prefix} || return

	for la in $(find ${u_prefix}/lib -name '*.la'); do
		sed -i "s|${u_prefix}|${w_prefix}|g" $la
	done

	if test -d ${u_prefix}/lib/pkgconfig; then
		for pc in $(find ${u_prefix}/lib/pkgconfig -name '*.pc'); do
			sed -i "s|${u_prefix}|${w_prefix}|g" $pc
			sed -i -E "s|-Wl,([^[:space:]]+).lib|-l\1|g" $pc
		done
	fi

	if test -d ${u_prefix}/share/info; then
		if type install-info >/dev/null 2>&1; then
			for i in ${u_prefix}/share/info/*.info; do
				install-info $i ${u_prefix}/share/info/dir
			done
		fi
	fi
}
