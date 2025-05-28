#!/bin/sh

##
# Build options
#

# Whether to build static libraries (has no effect with --static)
#
# See STATIC.md for details
#
ENABLE_STATIC=false

##
# Make
#

# Options to pass to `make` when building
MAKE_JOBS='-j -Otarget --no-print-directory'

# Whether to run `make check` for built packages
MAKE_CHECK=false

##
# CMake and Meson
#

# Whether to run `ctest` and `meson test` for built packages
ENABLE_TESTS=true

# CMake Generator to use
export CMAKE_GENERATOR='Ninja'
