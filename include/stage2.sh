#!/bin/env sh

# Set variable for stage 2

stage=2

if [ ${save_PATH+y} ]; then
	PATH=${save_PATH}
	unset save_PATH
fi

PATH=${u_prefix}/bin:${u_build_prefix}/bin:${PATH}

# Set varaibles for use with configure-based packages

. ${dir_include}/tools.sh

# Help CMake find dependencies

export CMAKE_PREFIX_PATH="${PREFIX};${BUILD_PREFIX}"

# Help pkgconf/pkg-config find dependencies

export PKG_CONFIG_LIBDIR=${u_prefix}/lib/pkgconfig:${u_prefix}/share/pkgconfig
export PKG_CONFIG_PATH=${u_build_prefix}/lib/pkgconfig:${u_build_prefix}/share/pkgconfig
