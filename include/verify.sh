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

case ${opt_winver} in
winxp)
	winver=0x0501
	;;
winvista)
	winver=0x0600
	;;
win7)
	winver=0x0601
	;;
win8)
	winver=0x0602
	;;
win8.1)
	winver=0x0603
	;;
win10)
	winver=0x0A00
	;;
*)
	die "--winver: ${opt_winver}: invalid value"
	;;
esac

# Verify directories

if [ -z "${PREFIX}" ]; then
	_die=true
	error "PREFIX is not set"
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

# Build options

# NOTE: --static overrides ENABLE_SHARED and ENABLE_STATIC
if ! ${ENABLE_SHARED} && ! ${ENABLE_STATIC} && ! ${opt_static}; then
	_die=true
	error "either ENABLE_SHARED or ENABLE_STATIC must be enabled"
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

# Verify dependencies

if ${WITH_LIBINTL}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "libintl: missing dependency: libiconv"
	fi
fi

if ${WITH_LIBTRE}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "libtre: missing dependency: libiconv"
	fi
	if ! ${WITH_LIBINTL}; then
		_die=true
		error "libtre: missing dependency: libintl"
	fi
fi

if ${WITH_LIBTEXTSTYLE}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "libtextstyle: missing dependency: libiconv"
	fi
fi

if ${WITH_LIBUNISTRING}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "libunistring: missing dependency: libiconv"
	fi
fi

if ${WITH_LIBXML2}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "libxml2: missing dependency: libiconv"
	fi
fi

if ${WITH_M4}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "m4: missing dependency: libiconv"
	fi
	if ! ${WITH_LIBINTL}; then
		_die=true
		error "m4: missing dependency: libintl"
	fi
fi

if ${WITH_BISON}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "bison: missing dependency: libiconv"
	fi
	if ! ${WITH_LIBINTL}; then
		_die=true
		error "bison: missing dependency: libintl"
	fi
	if ! ${WITH_M4}; then
		_die=true
		error "bison: missing dependency: m4"
	fi
fi

if ${WITH_GETTEXT}; then
	if ! ${WITH_LIBICONV}; then
		_die=true
		error "gettext: missing dependency: libiconv"
	fi
fi

# if ${WITH_AUTOCONF}; then
# 	if ! ${WITH_M4}; then
# 		_die=true
# 		error "autoconf: missing dependency: m4"
# 	fi
# fi

if ${WITH_LIBTOOL}; then
	if ! ${WITH_AUTOCONF}; then
		_die=true
		error "libtool: missing dependency: autoconf"
	fi
fi

if ${WITH_AUTOMAKE}; then
	if ! ${WITH_AUTOCONF}; then
		_die=true
		error "libtool: missing dependency: autoconf"
	fi
fi

# Abort if errors detected

if ${_die}; then
	die "invalid configuration"
fi
