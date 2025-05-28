#!/bin/sh

##
# Set stage-specific variables
#

if ${_need_tools-true}; then
	. ${dir_include}/tools.sh
fi

if [ ${save_PATH+y} ]; then
	PATH=${save_PATH}
fi

save_PATH=${PATH}

if [ ${stage} -eq 1 ]; then
	PATH=${u_build_prefix}/bin:${PATH}
elif [ ${stage} -eq 2 ]; then
	PATH=${u_prefix}/bin:${u_build_prefix}/bin:${PATH}
else # stage 3
	PATH=${u_programs_prefix}/bin:${u_prefix}/bin:${PATH}
fi

# Help CMake find dependencies
export CMAKE_PREFIX_PATH=

# Help pkgconf/pkg-config find dependencies
export PKG_CONFIG_LIBDIR=
export PKG_CONFIG_PATH=

if [ ${stage} -eq 1 ]; then
	CMAKE_PREFIX_PATH="${build_prefix}"
	PKG_CONFIG_LIBDIR="${build_prefix}/lib/pkgconfig;${build_prefix}/share/pkgconfig"
elif [ ${stage} -eq 2 ]; then
	CMAKE_PREFIX_PATH="${PREFIX};${build_prefix}"
	PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig;${PREFIX}/share/pkgconfig"
	PKG_CONFIG_PATH="${build_prefix}/lib/pkgconfig;${build_prefix}/share/pkgconfig"
else # stage 3
	CMAKE_PREFIX_PATH="${PREFIX}"
	PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig;${PREFIX}/share/pkgconfig"

	if [ "${PREFIX}" != "${PROGRAMS_PREFIX}" ]; then
		CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${PROGRAMS_PREFIX}"
		PKG_CONFIG_PATH="${PROGRAMS_PREFIX}/lib/pkgconfig;${PROGRAMS_PREFIX}/share/pkgconfig"
	fi
fi

# Compiler and Linker flags for configure-based packages
. ${dir_include}/flags.sh
