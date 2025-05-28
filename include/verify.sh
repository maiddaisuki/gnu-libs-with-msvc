#!/bin/sh

##
# Verify user config
#

_die=false

# Command-line options

case ${opt_buildtype} in
release | small-release | debug)
	:
	;;
*)
	_die=true
	error "--buildtype: ${opt_buildtype}: invalid value"
	;;
esac

# Verify directories

if [ -z "${PREFIX}" ]; then
	_die=true
	error "PREFIX is not set"
fi

if [ -z "${PROGRAMS_PREFIX}" ]; then
	_die=true
	error "PROGRAMS_PREFIX is not set"
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
