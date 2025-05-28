#/bin/sh

##
# Build directories
#

# Installation prefix to use during stage 1
build_prefix=${BUILDDIR}/prefix.tmp
u_build_prefix=$(cygpath -u "${build_prefix}")
