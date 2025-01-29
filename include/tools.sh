#!/bin/env sh

# Set stage-specific tool variables

# find GNU Automake's `compile` and `ar-lib` wrapper scripts

_automake_version=$(automake --version | sed -E '1s/.*([[:digit:]]+\.[[:digit:]]+)$/\1/ ; q')

compile=/usr/share/automake-${_automake_version}/compile
ar_lib=/usr/share/automake-${_automake_version}/ar-lib

if [ ! -f ${ar_lib} ] || [ ! -f ${compile} ]; then
	die "failed to locate 'compile' and 'ar-lib' provided by GNU Automake"
fi

# tools to use with `configure`

if [ ${opt_toolchain} = msvc ]; then
	c_compiler=cl.exe
	cxx_compiler=cl.exe

	cc="${compile} cl.exe -nologo"
	cxx="${compile} cl.exe -nologo"

	if type ml64.exe >/dev/null 2>&1; then
		as='ml64.exe -nologo'
	elif type ml.exe >/dev/null 2>&1; then
		as='ml.exe -nologo'
	else
		as=:
	fi

	ld='link.exe -nologo'

	ar="${ar_lib} lib.exe"
	ranlib=:

	objdump='dumpbin.exe -nologo'
	nm="${objdump} -symbols"

	objcopy=:
	strip=:

	dlltool=:
elif [ ${opt_toolchain} = llvm ]; then
	c_compiler=clang-cl.exe
	cxx_compiler=clang-cl.exe

	cc="${compile} clang-cl.exe"
	cxx="${compile} clang-cl.exe"

	as=llvm-as.exe
	ld=lld-link.exe

	ar=llvm-ar.exe
	ranlib=llvm-ranlib.exe

	objdump=llvm-objdump.exe
	nm=llvm-nm.exe

	objcopy=llvm-objcopy.exe
	strip=llvm-strip.exe

	dlltool=llvm-dlltool.exe
fi

# set header and library search paths
#
# NOTE: `-external` flag tells cl.exe to treat headers in specified directory
# as *external* (similar to *system* in gcc)

_incpath=
_libpath=

if [ ${stage} = 1 ]; then
	_incpath="-I${u_build_prefix}/include -external:I${BUILD_PREFIX}/include -external:W0"
	_libpath="-L${u_build_prefix}/lib"
elif [ ${stage} = 2 ]; then
	_incpath="-I${u_prefix}/include -external:I${PREFIX}/include -I${u_build_prefix}/include -external:I${BUILD_PREFIX}/include -external:W0"
	_libpath="-L${u_prefix}/lib -L${u_build_prefix}/lib"
elif [ ${stage} = 3 ]; then
	_incpath="-I${u_programs_prefix}/include -external:I${PROGRAMS_PREFIX}/include -I${u_prefix}/include -external:I${PREFIX}/include -external:W0"
	_libpath="-L${u_programs_prefix}/lib -L${u_prefix}/lib"
fi

# compiler flags to use with `configure`

if ${opt_debug}; then
	cppflags=
	# work around libtool bug...
	ldflags=-Wl,-Xlinker,-debug
else
	cppflags='-DNDEBUG'
	ldflags=
fi

if ${opt_static}; then
	if ${opt_debug}; then
		cflags="-MTd -Od -Z7"
	else
		cflags="-MT -O2"
	fi
else
	if ${opt_debug}; then
		cflags="-MDd -Od -Z7"
	else
		cflags="-MD -O2"
	fi
fi

cppflags="${cppflags} -D_CRT_SECURE_NO_WARNINGS"
cflags="${cflags} -utf-8"
cxxflags="${cflags} -EHsc -permissive-"

if [ ${opt_toolchain} = llvm ]; then
	cflags="${cflags} -w"
	cxxflags="${cxxflags} -w"
fi

# request specific C and C++ standards

if ${opt_legacy}; then :; else
	cppflags="${cppflags} -D_CRT_DECLARE_NONSTDC_NAMES"
	cflags="${cflags} -std:c17 -Zc:__STDC__"
	cxxflags="${cxxflags} -std:c++20 -Zc:__cplusplus"
fi

# Add user flags

cppflags="${_incpath} ${cppflags} ${CPPFLAGS}"
cflags="${cflags} ${CFLAGS}"
cxxflags="${cxxflags} ${CXXFLAGS}"
ldflags="${_libpath} ${ldflags} ${LDFLAGS}"
