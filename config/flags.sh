#!/bin/sh

##
# Compiler and Linker flags
#
# LDFLAGS must contain flags as if you would pass them directly to link.exe.
# If you need to pass compiler flags which affect linking, you must pass them
# in C[XX]FLAGS instead.
#
# This is important since libtool uses compiler for linking, and each
# flag listed in LDFLAGS must be passed to the linker with -Wl, or -Xlinker.
#

CPPFLAGS=
CFLAGS=
CXXFLAGS=
LDFLAGS=
