#!/bin/sh

##
# Shared and Static libraries
#

if ${build_shared}; then
	enable_shared=--enable-shared
	build_shared_libs=ON
else
	enable_shared=--disable-shared
	build_shared_libs=OFF
fi

if ${build_static}; then
	enable_static=--enable-static
	build_static_libs=ON
else
	enable_static=--disable-static
	build_static_libs=OFF
fi

# For meson
if ${build_shared} && ${build_static}; then
	default_library=both
elif ${build_shared}; then
	default_library=shared
else
	default_library=static
fi

##
# CRT type
#

if ${opt_static}; then
	if ${opt_debug}; then
		msvc_runtime_library=MultiThreadedDebug
		b_vscrt=mtd
	else
		msvc_runtime_library=MultiThreaded
		b_vscrt=mt
	fi
else
	if ${opt_debug}; then
		b_vscrt=mdd
		msvc_runtime_library=MultiThreadedDebugDLL
	else
		b_vscrt=md
		msvc_runtime_library=MultiThreadedDLL
	fi
fi

##
# Build type: optimizations and debug info
#

build_cppflags="-D_WIN32_WINNT=${winver}"
build_cflags=
build_cxxflags=
build_ldflags=

case ${opt_buildtype} in
release)
	build_cppflags="${build_cppflags} -DNDEBUG"
	build_cflags="-O2 -Ob2"
	build_cxxflags="-O2 -Ob2"
	build_ldflags="-release"

	# meson
	b_ndebug=true
	;;
small-release)
	build_cppflags="${build_cppflags} -DNDEBUG"
	build_cflags="-O1 -Ob1"
	build_cxxflags="-O1 -Ob1"
	build_ldflags="-release"

	# meson
	b_ndebug=true
	;;
debug)
	build_cppflags="${build_cppflags}"
	build_cflags="-Od -Ob0 -Z7"
	build_cxxflags="-Od -Ob0 -Z7"
	build_ldflags="-debug"

	# meson
	b_ndebug=false
	;;
esac
