# Packages

The following packages are supported:

- [autoconf](https://www.gnu.org/software/autoconf)
- [automake](https://www.gnu.org/software/automake)
- [bison](https://www.gnu.org/software/bison)
- [bzip2](https://sourceware.org/bzip2)
- [gettext](https://www.gnu.org/software/gettext)
  (`libintl`, `libasprintf`, `libtextstyle` and `gettext`)
- [json-c](https://github.com/json-c/json-c)
- [libiconv](https://www.gnu.org/software/libiconv)
- [libidn2](https://gitlab.com/libidn/libidn2)
- [libpsl](https://github.com/rockdaboot/libpsl)
- [libtool](https://www.gnu.org/software/libtool)
- [libtre](https://laurikari.net/tre)
- [libunistring](https://www.gnu.org/software/libunistring)
- [libxml2](https://gitlab.gnome.org/GNOME/libxml2)
- [m4](https://www.gnu.org/software/m4)
- [ncurses](https://invisible-island.net/ncurses)
- [pkgconf](https://github.com/pkgconf/pkgconf)
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

Dependencies:

- libiconv
- libintl
- m4

Optional dependencies:

- libtextstyle
- readline (TODO)

### gettext

In releases from `0.23` to `0.25`, `gettextlib.dll` and `gettextsrc.dll` are
affected by a bug which causes programs linked against them crash at runtime.
This bug has been fixed in release `0.26`.

If you need to build one of those versions, you need to pass
`--disable-shared --enable-static` explicitly to `gettext`'s configure
script in [gettext.sh](/packages/gettext.sh).

Note that this does not affect `libintl`, `libasprintf` and `libtextstyle`.

Dependencies:

- libiconv

Optional dependencies:

- libunistring
- libxml2

### json-c

No dependencies.

### libasprintf

Optional part of `gettext` package.

No dependencies.

### libiconv

Has optional circular dependency on `libintl`.

### libidn2

Dependencies:

- libiconv

Optional dependencies:

- libintl
- libunistring

### libintl

Part of `gettext` package.

`libintl` is required for `gettext-tools` and will always be built with
`WITH_GETTEXT=true` regardless of `WITH_LIBINTL`.

Dependencies:

- libiconv

### libpsl

One of the following sets of libraries is required:

- libiconv + libidn2 + libunistring
- libiconv + libidn (TODO) + libunistring
- libicu (TODO)

Optional dependencies:

- libintl

### libtextstyle

Optional part of `gettext` package.

`libtextstyle` is required for `gettext-tools` and will always be built with
`WITH_GETTEXT=true` regardless of `WITH_LIBTEXTSTYLE`.

Dependencies:

- libiconv

Optional dependencies:

- ncurses

### libtool

Also installs `libltdl` library.

### libtre

Required by `libgnurx` (`libsystre`) which is not yet supported.

Dependencies:

- libiconv
- libintl

Optional dependencies:

- libutf8 (TODO?)

### libunistring

Building `libunistring-1.3` from source tarball fails due to a `libtool` bug.
Use any later version, release `1.2`, or build from `master`.

Dependencies:

- libiconv

### libxml2

Will be configured to use `libiconv`.

Dependencies:

- libiconv

Optional dependencies:

- readline (TODO)
- zlib (TODO)

### m4

Building `m4-1.4.20` fails. You can build from `master` or a recent stable tag
with recent enough `gnulib` sources.

Warning: `m4` seems to have issues on native Windows.

Dependencies:

- libiconv
- libintl

Optional dependencies:

- libsigsegv (TODO)

### ncurses

The build system is purely `autoconf`-based and does not use `automake` and
`libtool`.  
However, it allows to use installed `libtool` script to build libraries.

We will install `libtool` script configured to be used with MSVC/LLVM tools,
and will use it to build `ncurses`.

This means that you need to obtain source code for `libtool` if you want to
build `ncurses`.

### pkgconf

While not required, it is highly recommended to build `pkgconf`.

No dependencies.

### winpthreads

`WINPTHREADS_SRCDIR` must point to `mingw-w64-libraries/winpthreads`
subdirectory of `mingw-w64` repository.

No dependencies.

## External Build System

Some packages use build system which works poorly with MSVC tool or
does not work at all. For such packages we provide `Meson` build file which
you can use to build recent versions of those packages.

### bzip2

`bzip2` provides Makefiles for `make` and `nmake`.
We provide `meson.build` to build it.

See [patches/bzip2/README.md](/patches/bzip2/README.md) for details.
