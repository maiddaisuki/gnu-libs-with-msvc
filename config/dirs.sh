#!/bin/sh

##
# Specify build, source and installation directories
#
# Use windows-style filenames with forward slashes e.g. 'C:/some/dir'
#

# Installation prefix
PREFIX=

# Root for relative *_SRCDIR directories
SRCDIR=

# Root for build directories
#
# If you use default ${TEMP}, keep in mind that this directory
# will not be cleaned up on shutdown
#
BUILDDIR=${TEMP}

##
# Source directories
#
# Absolute names are used as-is.
# Relative names are appended to SRCDIR.
#

AUTOCONF_SRCDIR=
AUTOMAKE_SRCDIR=
BISON_SRCDIR=
BZIP2_SRCDIR=
FLEX_SRCDIR=
GETTEXT_SRCDIR=
LIBICONV_SRCDIR=
LIBTOOL_SRCDIR=
LIBUNISTRING_SRCDIR=
LIBXML2_SRCDIR=
M4_SRCDIR=
NCURSES_SRCDIR=
PERL_SRCDIR=
PKGCONF_SRCDIR=
READLINE_SRCDIR=
TRE_SRCDIR=
WINPTHREADS_SRCDIR=
