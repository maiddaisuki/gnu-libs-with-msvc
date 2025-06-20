#!/bin/sh

##
# The post_install function
#
# Convert unix-style paths in *.la and *.pc files to windows-style paths.
# Run install-info to make info manuals in PREFIX/share/info usable.
#
post_install() {
	test -d ${u_prefix} || return

	local la pc i

	for la in $(find "${u_prefix}/lib" -name '*.la'); do
		sed -i "s|${u_prefix}|${PREFIX}|g" $la
	done

	if test -d "${u_prefix}/lib/pkgconfig"; then
		for pc in $(find "${u_prefix}/lib/pkgconfig" -name '*.pc'); do
			sed -i "s|${u_prefix}|${PREFIX}|g" $pc
		done
	fi

	if test -d "${u_prefix}/share/pkgconfig"; then
		for pc in $(find "${u_prefix}/share/pkgconfig" -name '*.pc'); do
			sed -i "s|${u_prefix}|${PREFIX}|g" $pc
		done
	fi

	if test -d "${u_prefix}/share/info"; then
		if type install-info >/dev/null 2>&1; then
			for i in $(find "${u_prefix}/share/info" -name '*.info'); do
				install-info $i ${u_prefix}/share/info/dir
			done
		fi
	fi
}
