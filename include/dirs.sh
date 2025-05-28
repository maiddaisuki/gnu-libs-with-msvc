#/bin/sh

##
# Build directories
#

# Installation prefix to use during stage 1
build_prefix=${BUILDDIR}/prefix.tmp

##
# Values of PREFIX, PROGRAMS_PREFIX and build_prefix converted to unix-style
# paths
#

u_prefix=$(cygpath -u "${PREFIX}")
u_programs_prefix=$(cygpath -u "${PROGRAMS_PREFIX}")
u_build_prefix=$(cygpath -u "${build_prefix}")
