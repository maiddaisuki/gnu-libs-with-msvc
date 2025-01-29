#!/bin/env sh

# Set variable for stage 1

stage=1

save_PATH=${PATH}
PATH=${u_build_prefix}/bin:${PATH}

# Set varaibles for use with configure-based packages

. ${dir_include}/tools.sh

# Help CMake find dependencies

export CMAKE_PREFIX_PATH=${BUILD_PREFIX}

# Help pkgconf/pkg-config find dependencies

export PKG_CONFIG_LIBDIR=${u_build_prefix}/lib/pkgconfig:${u_build_prefix}/share/pkgconfig
export PKG_CONFIG_PATH=
