# packages/README.md

The following packages are supported:

- [Autoconf](https://www.gnu.org/software/autoconf)
- [Automake](https://www.gnu.org/software/automake)
- [Bison](https://www.gnu.org/software/bison)
- [bzip2](https://sourceware.org/bzip2)
- [Gettext](https://www.gnu.org/software/gettext)
  (`libintl`, `libasprintf`, `libtextstyle` and `gettext`)
- [libiconv](https://www.gnu.org/software/libiconv)
- [libtool](https://www.gnu.org/software/libtool)
- [libtre](https://laurikari.net/tre)
- [libunistring](https://www.gnu.org/software/libunistring)
- [libxml2](https://gitlab.gnome.org/GNOME/libxml2)
- [M4](https://www.gnu.org/software/m4)
- [ncurses](https://invisible-island.net/ncurses)
- [mingw-w64's](https://www.mingw-w64.org) `winpthreads`

The `autoconf`, `automake` and `libtool` packages are built by
`progs-with-msvc.sh` only if `--with-autotools` option is passed.

## Supported Packages

### Bison

Building `bison-3.8.2` fails. Older versions may work.

Testsuite seems to fail a lot.

### Gettext

Starting with release `0.23`, `gettextlib.dll` and `gettextsrc.dll` are
affected by a bug which causes programs linked against them crash at runtime.

To build working programs, `gettext-tools` will be configured with
`--disable-shared --enable-static`.

Note that this does not affect `libintl`, `libasprintf` and `libtextstyle`.

### Libtool

Installed `libtool` script does not work properly.

The `libtool` package comes with `libltdl` library. It is built and installed
with `progs-with-msvc.sh`.

### libtre

Required by `libgnurx` (`libsystre`) which is not yet supported.

### libunistring

Building `libunistring-1.3` from source tarball fails due to a `libtool` bug.
Use any later version, release `1.2`, or build from `master`.

### libxml2

Supports both `GNU Autotools` and `CMake` build systems.

### M4

Building `m4-1.4.20` fails. Older versions may work.

Testsuite seems to fail a lot.

### Ncurses

The build system is purely `autoconf`-based and does not use `automake` and
`libtool`.  
However, it allows to use installed `libtool` script to build libraries.

Unfortunately, installed `libtool` script does not work properly, but it still
can be used to build libraries.

We provide two ways to build `ncurses`.

First option is to use `--ncurses-static`. This will build `ncurses` as a static
library only regardless of `--static` option. However, in this case`libtool` will refuse to
create shared libraries which link against it.

This is a `libtool` issue and this behavior is annoying and probably
should be changed.

Another solution is to configure and install `libtool` for MSVC tools.
Unfortunately, installed `libtool` script will create invalid `*.la` files which
will make library unusable. This will cause build to fail.

You will need to manually edit generated `*.la` files during the build process.

Once build fails, navigate to `${BUILDDIR}/stage-2/build/ncurses/lib`
and edit all `*.la` files by replacing

```text
library_names='lib{NAME}.dll lib{NAME}.lib'
```

with

```text
library_names'lib{NAME}.dll lib{NAME}.dll.lib`
```

After this run `libs-with-msvc.sh` with `--ncurses-workaround` option:

```shell
./libs-with-msvc.sh --ncurses-workaround
```

You will need to repeat this process at least twice.

The `libs-with-msvc.sh` will patch installed `*.la` files to make library usable
and rename import and static libraries to follow `libtool` conventions for MSVC
tools.

### winpthreads

`WINPTHREADS_SRCDIR` must point to `mingw-w64-libraries/winpthreads`
subdirectory of `mingw-w64` repository.

Testsuite can only be run with static libraries.

## External Build System

Some packages use build system which works poorly with MSVC tool or
does not work at all. For such packages we provide `Meson` build file which
you can use to build recent versions of those packages.

### bzip2

By default, `bzip2` provides Makefiles for `make` and `nmake`. We provide
`meson.build` to build it.

Copy [patches/bzip2/meson.build](/patches/bzip2/meson.build) to the root of
cloned `bzip2` repository or extracted source tarball.

You will also need to modify file `libbz2.def`. Prepend the first two lines
with `;`, or simply remove them.

You may also need to change value of `version` keyword in `project` call.
Current value is `1.0.8`.
