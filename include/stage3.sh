#!/bin/sh

##
# Set variable for stage 3
#

stage=3

PATH=${u_programs_prefix}/bin:${u_prefix}/bin:${PATH}

# Set varaibles for use with configure-based packages
. ${dir_include}/tools.sh

# Help CMake find dependencies
export CMAKE_PREFIX_PATH=${PREFIX}

# Help pkgconf/pkg-config find dependencies
export PKG_CONFIG_LIBDIR=${u_prefix}/lib/pkgconfig:${u_prefix}/share/pkgconfig
export PKG_CONFIG_PATH=

if [ ${u_prefix} != ${u_programs_prefix} ]; then
	export CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH};${PROGRAMS_PREFIX}"
	export PKG_CONFIG_PATH=${u_programs_prefix}/lib/pkgconfig:${u_programs_prefix}/share/pkgconfig
fi
