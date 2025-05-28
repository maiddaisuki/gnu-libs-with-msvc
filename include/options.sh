#!/bin/sh

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
