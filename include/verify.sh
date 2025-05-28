#!/bin/sh

##
# Verify user config
#

_die=false

# Verify directories

if [ -z "${PREFIX}" ]; then
	_die=true
	error "PREFIX is not set"
fi

if [ -z "${PROGRAMS_PREFIX}" ]; then
	_die=true
	error "PROGRAMS_PREFIX is not set"
fi

if [ -z "${BUILD_PREFIX}" ]; then
	_die=true
	error "BUILD_PREFIX is not set"
fi

if [ -z "${BUILDDIR}" ]; then
	_die=true
	error "BUILDDIR is not set"
fi

if [ -z "${SRCDIR}" ]; then
	_die=true
	error "SRCDIR is not set"
elif [ ! -d "${SRCDIR}" ]; then
	_die=true
	error "SRCDIR=${SRCDOR}: directory does not exist"
fi

# Unsupported packages

if ${WITH_EMACS}; then
	_die=true
	error "WITH_EMACS=true; package not supported"
fi

if ${WITH_LIBSIGSEGV}; then
	_die=true
	error "WITH_LIBSIGSEGV=true; package not supported"
fi

if ${WITH_LZMA}; then
	_die=true
	error "WITH_LZMA=true; package not supported"
fi

if ${WITH_READLINE}; then
	_die=true
	error "WITH_READLINE=true; package not supported"
fi

if ${WITH_ZLIB}; then
	_die=true
	error "WITH_ZLIB=true; package not supported"
fi

if ${_die}; then
	die "invalid configuration"
fi

##
# Shared and Static libraries
#

if ${opt_debug}; then
	cmake_build_type=Debug
	buildtype=debug
else
	cmake_build_type=Release
	buildtype=release
fi

if ${opt_static}; then
	enable_static=--enable-static
	enable_shared=--disable-shared

	build_static_libs=ON
	build_shared_libs=OFF

	default_library=static

	if ${opt_debug}; then
		msvc_runtime_library=MultiThreadedDebug
		vscrt=mtd
	else
		msvc_runtime_library=MultiThreaded
		vscrt=mt
	fi
else
	enable_shared=--enable-shared
	build_shared_libs=ON

	if ${ENABLE_STATIC}; then
		enable_static=--enable-static
		build_static_libs=ON
		default_library=both
	else
		enable_static=--disable-static
		build_static_libs=OFF
		default_library=shared
	fi

	if ${opt_debug}; then
		vscrt=mdd
		msvc_runtime_library=MultiThreadedDebugDLL
	else
		vscrt=md
		msvc_runtime_library=MultiThreadedDLL
	fi
fi

# unix-style values for PREFIX, PROGRAMS_PREFIX and BUILD_PREFIX

u_prefix=$(cygpath -u "${PREFIX}")
u_programs_prefix=$(cygpath -u "${PROGRAMS_PREFIX}")
u_build_prefix=$(cygpath -u "${BUILD_PREFIX}")
