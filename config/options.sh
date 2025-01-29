#!/bin/env sh

# Build options

# Whether to build static libraries (has no effect with --static)
#
# NOTE: see STATIC.md
#
ENABLE_STATIC=false

# Options to pass to `make` when building
#
#MAKE_JOBS='-j -Otarget --no-print-directory'

# Whether to run `make check` for built packages
#
MAKE_CHECK=false

# Whether to run `ctest` and `meson test` for built packages
#
ENABLE_TESTS=true

# CMake Generator to use
#
# CMake usually comes with Ninja
#
export CMAKE_GENERATOR='Ninja'
