#!/bin/sh

##
# Set stage-specific variables
#

if ${_need_tools-true}; then
	. ${dir_include}/tools.sh
fi

# Restore values, if they were saved
test ${save_INCLUDE+y} && INCLUDE=${save_INCLUDE}
test ${save_LIB+y} && LIB=${save_LIB}
test ${save_PATH+y} && PATH=${save_PATH}

# Save current values
save_INCLUDE=${INCLUDE}
save_LIB=${LIB}
save_PATH=${PATH}

# Help CMake find dependencies
export CMAKE_PREFIX_PATH=

# Help pkgconf/pkg-config find dependencies
export PKG_CONFIG_LIBDIR=
export PKG_CONFIG_PATH=

if [ ${stage} -eq 1 ]; then
	PATH=${u_build_prefix}/bin:${PATH}
	INCLUDE="${build_prefix}/include;${INCLUDE}"
	LIB="${build_prefix}/lib;${LIB}"
	CMAKE_PREFIX_PATH="${build_prefix}"
	PKG_CONFIG_LIBDIR="${build_prefix}/lib/pkgconfig;${build_prefix}/share/pkgconfig"
else # stage 2 and 3
	if [ ${stage} -eq 2 ]; then
		PATH=${u_build_prefix}/bin:${PATH}
		INCLUDE="${build_prefix}/include;${INCLUDE}"
		LIB="${build_prefix}/lib;${LIB}"
		CMAKE_PREFIX_PATH="${build_prefix}"
		PKG_CONFIG_PATH="${build_prefix}/lib/pkgconfig;${build_prefix}/share/pkgconfig"
	fi

	PATH=${u_prefix}/bin:${PATH}
	INCLUDE="${PREFIX}/include;${INCLUDE}"
	LIB="${PREFIX}/lib;${LIB}"
	CMAKE_PREFIX_PATH="${PREFIX}"
	PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig;${PREFIX}/share/pkgconfig"
fi

# Compiler and Linker flags for configure-based packages
if ${_need_flags-true}; then
	. ${dir_include}/flags.sh
fi
