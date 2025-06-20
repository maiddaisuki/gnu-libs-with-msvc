# Packages

The following packages are supported:

- [autoconf](https://www.gnu.org/software/autoconf)
- [automake](https://www.gnu.org/software/automake)
- [bison](https://www.gnu.org/software/bison)
- [bzip2](https://sourceware.org/bzip2)
- [gettext](https://www.gnu.org/software/gettext)
  (`libintl`, `libasprintf`, `libtextstyle` and `gettext`)
- [libiconv](https://www.gnu.org/software/libiconv)
- [libtool](https://www.gnu.org/software/libtool)
- [libtre](https://laurikari.net/tre)
- [libunistring](https://www.gnu.org/software/libunistring)
- [libxml2](https://gitlab.gnome.org/GNOME/libxml2)
- [m4](https://www.gnu.org/software/m4)
- [ncurses](https://invisible-island.net/ncurses)
- [mingw-w64's](https://www.mingw-w64.org) `winpthreads`

## Supported Packages

### autoconf

Native Windows build is not supported.

### automake

Native Windows build is not supported.

### bison

Building `bison-3.8.2` fails.
You can build from `master` with recent enough `gnulib` sources.

Warning: `bison` does not function properly on native Windows.

### gettext

Starting with release `0.23`, `gettextlib.dll` and `gettextsrc.dll` are
affected by a bug which causes programs linked against them crash at runtime.

To build working programs, `gettext-tools` will be configured with
`--disable-shared --enable-static`.

Note that this does not affect `libintl`, `libasprintf` and `libtextstyle`.

Optional dependencies:

- libunistring
- libxml2

### libasprintf

Optional part of `gettext` package.

### libiconv

Part of `gettext` package.

Always built.

### libintl

Always built.

### libtextstyle

Optional part of `gettext` package.

`libtextstyle` is required for `gettext-tools` and will always be built with
`WITH_GETTEXT=true` regardless of `WITH_LIBTEXTSTYLE`.

Optional dependencies:

- ncurses

### libtool

Also installs `libltdl` library.

### libtre

Required by `libgnurx` (`libsystre`) which is not yet supported.

### libunistring

Building `libunistring-1.3` from source tarball fails due to a `libtool` bug.
Use any later version, release `1.2`, or build from `master`.

### libxml2

Will be configured to use `libiconv`.

Optional dependencies:

- lzma (TODO)
- readline (TODO)
- zlib (TODO)

### m4

Building `m4-1.4.20` fails. You can build from `master` or a recent stable tag
with recent enough `gnulib` sources.

Warning: `m4` seems to have issues on native Windows.

### ncurses

The build system is purely `autoconf`-based and does not use `automake` and
`libtool`.  
However, it allows to use installed `libtool` script to build libraries.

We will install `libtool` script configured to be used with MSVC/LLVM tools,
and will use it to build `ncurses`.

This means that you need to obtain source code for `libtool` if you want to
build `ncurses`.

### winpthreads

`WINPTHREADS_SRCDIR` must point to `mingw-w64-libraries/winpthreads`
subdirectory of `mingw-w64` repository.

## External Build System

Some packages use build system which works poorly with MSVC tool or
does not work at all. For such packages we provide `Meson` build file which
you can use to build recent versions of those packages.

### bzip2

`bzip2` provides Makefiles for `make` and `nmake`.
We provide `meson.build` to build it.

See [patches/bzip2/README.md](/patches/bzip2/README.md) for details.
