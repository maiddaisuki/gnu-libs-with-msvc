#!/bin/sh

##
# Set compiler and linker flags
#

##
# Set header and library search paths
#
# NOTE: `-external` flag tells cl.exe to treat headers in specified directory
# as *external* (similar to *system* in gcc)
#

_incpath=
_libpath=

if [ ${stage} = 1 ]; then
	_incpath="-I${u_build_prefix}/include -external:I${build_prefix}/include -external:W0"
	_libpath="-L${u_build_prefix}/lib"
elif [ ${stage} = 2 ]; then
	_incpath="-I${u_prefix}/include -external:I${PREFIX}/include -I${u_build_prefix}/include -external:I${build_prefix}/include -external:W0"
	_libpath="-L${u_prefix}/lib -L${u_build_prefix}/lib"
elif [ ${stage} = 3 ]; then
	_incpath="-I${u_programs_prefix}/include -external:I${PROGRAMS_PREFIX}/include -I${u_prefix}/include -external:I${PREFIX}/include -external:W0"
	_libpath="-L${u_programs_prefix}/lib -L${u_prefix}/lib"
fi

##
# Compiler and Linker flags
#

# workaround libtool bug...
_Wl="-Wl,-Xlinker,"

# Request specific C and C++ standards

if ${opt_legacy}; then
	cppflags=
	cflags=
	cxxflags=
	ldflags=
else
	cppflags="-D_CRT_DECLARE_NONSTDC_NAMES"
	cflags="-std:c17 -Zc:__STDC__"
	cxxflags="-std:c++20 -Zc:__cplusplus"
	ldflags=
fi

cppflags="${cppflags} -D_CRT_SECURE_NO_WARNINGS"
cflags="${cflags} -utf-8"
cxxflags="${cflags} -EHsc -permissive-"
ldflags="${ldflags}"

##
# CRT type
#

if ${opt_static}; then
	if ${opt_debug}; then
		cflags="${cflags} -MTd"
	else
		cflags="${cflags} -MT"
	fi
else
	if ${opt_debug}; then
		cflags="${cflags} -MDd"
	else
		cflags="${cflags} -MD"
	fi
fi

##
# Build type: optimizations and debug info
#

case ${opt_buildtype} in
release)
	cppflags="${cppflags} -DNDEBUG"
	cflags="${cflags} -O2 -Ob2"
	cxxflags="${cxxflags} -O2 -Ob2"
	ldflags="${ldflags} ${_Wl}-release"
	;;
small-release)
	cppflags="${cppflags} -DNDEBUG"
	cflags="${cflags} -O1 -Ob1"
	cxxflags="${cxxflags} -O1 -Ob1"
	ldflags="${ldflags} ${_Wl}-release"
	;;
debug)
	cflags="${cflags} -Od -Ob0 -Z7"
	cxxflags="${cxxflags} -Od -Ob0 -Z7"
	ldflags="${ldflags} ${_Wl}-debug"
	;;
esac

# Add user-supplied flags

cppflags="${_incpath} ${cppflags} ${CPPFLAGS}"
cflags="${cflags} ${CFLAGS}"
cxxflags="${cxxflags} ${CXXFLAGS}"
ldflags="${_libpath} ${ldflags} ${LDFLAGS}"
