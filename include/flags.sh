#!/bin/sh

##
# Set compiler and linker flags
#

# Make sure this file is read only once
_need_flags=false

# workaround libtool bug...
_Wl="-Wl,-Xlinker,"

cppflags=
cflags=
cxxflags=
ldflags=

##
# Compiler and Linker flags
#

# Request specific C and C++ standards
if ! ${opt_legacy}; then
	cppflags="-external:W0 -external:env:INCLUDE -D_CRT_DECLARE_NONSTDC_NAMES"
	cflags="-utf-8 -std:c17 -Zc:__STDC__"
	cxxflags="-utf-8 -std:c++20 -Zc:__cplusplus"
fi

cppflags="${cppflags} -D_CRT_SECURE_NO_WARNINGS"
cflags="${cflags}"
cxxflags="${cxxflags} -EHsc -permissive-"

# Use llvm linker with --llvm
if [ ${opt_toolchain} = llvm ]; then
	ldflags="${ldflags} -fuse-ld=lld"
fi

##
# CRT type
#

if ${opt_static}; then
	if ${opt_debug}; then
		cflags="${cflags} -MTd"
		cxxflags="${cxxflags} -MTd"
	else
		cflags="${cflags} -MT"
		cxxflags="${cxxflags} -MT"
	fi
else
	if ${opt_debug}; then
		cflags="${cflags} -MDd"
		cxxflags="${cxxflags} -MDd"
	else
		cflags="${cflags} -MD"
		cxxflags="${cxxflags} -MD"
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

##
# Add user-supplied flags
#

cppflags="${cppflags} ${CPPFLAGS}"
cflags="${cflags} ${CFLAGS}"
cxxflags="${cxxflags} ${CXXFLAGS}"

# Prepend "-Wl," to each linker flag listed in LDFLAGS
for i in ${LDFLAGS}; do
	ldflags="${ldflags} ${_Wl}$i"
done
