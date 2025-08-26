#!/bin/sh

##
# Build tools
#

# make sure this file is only read once
_need_tools=false

# Make Msys2 behave
export MSYS2_ARG_CONV_EXCL='-Tp;-Tc'

# Find GNU Automake's `compile` and `ar-lib` wrapper scripts

_automake_version=$(automake --version | sed -E '1s/.* ([[:digit:]]+\.[[:digit:]]+)(\.[[:digit:]])*$/\1/ ; q')

compile=/usr/share/automake-${_automake_version}/compile
ar_lib=/usr/share/automake-${_automake_version}/ar-lib

if [ ! -f ${ar_lib} ] || [ ! -f ${compile} ]; then
	die "failed to locate 'compile' and 'ar-lib' provided by GNU Automake"
fi

##
# Select either msvc or llvm tools
#

if [ ${opt_toolchain} = msvc ]; then
	# For use with cmake and meson
	c_compiler=cl.exe
	cxx_compiler=cl.exe

	# For use with configure script
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
	# For use with cmake and meson
	c_compiler=clang-cl.exe
	cxx_compiler=clang-cl.exe

	# For use with configure script
	cc="${compile} clang-cl.exe"
	cxx="${compile} clang-cl.exe"

	as=llvm-ml.exe
	ld=lld-link.exe

	ar=llvm-ar.exe
	ranlib=llvm-ranlib.exe

	objdump=llvm-objdump.exe
	# llvm-nm.exe cannot be used
	# https://lists.gnu.org/archive/html/bug-gnulib/2025-06/msg00086.html
	nm='dumpbin.exe -nologo -symbols'

	objcopy=llvm-objcopy.exe
	strip=: #llvm-strip.exe

	dlltool=llvm-dlltool.exe
fi
