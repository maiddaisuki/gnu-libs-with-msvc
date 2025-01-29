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

Cannot be built from tarball with at least latest MSVC tools due to `gnulib`
issues.

If you build `bison` from git, you may use `gnulib`'s tag `stable-202301` which
seems to at least allow package to build.

However, testsuite fails horribly and I cannot confirm that built `bison`
functions properly.

### Gettext

Save youself troubles trying to build from `git`. Use source tarball.

With latest MSVC tools, `gettext 23.0` programs crash at startup when built with
shared `libgettext*` libraries. A possible solution is to pass
`--enable-static --disable-shared` to `configure` in [gettext.sh](/packages/gettext.sh).

Linking of `src/msgfilter.c` fails with unresolved reference to `unsetenv`.
This is most likely `gnulib` bug. Solution is to add following lines after the
last `#include` directive in the file:

```c
static int unsetenv(const char *varname) {
	return _putenv_s(varname, "");
}
```

### Libtool

Installed `libtool` script does not work properly.

The `libtool` package comes with `libltdl` library. It is built and installed
with `progs-with-msvc.sh`.

### libtre

Required by `libgnurx` (`libsystre`) which is not yet supported.

### libxml2

Supports both `GNU Autotools` and `CMake` build systems.

### M4

Many tests in testsuite fail. May not work properly.

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

### winpthreads

mingw-64's `winpthreads` only support `GNU Autotools` as a build system.
It works poorly with MSVC tools. You will need to use provided `meson.build` and
to build it.

Copy [patches/winpthreads/meson.build](/patches/winpthreads/meson.build) to
`mingw-w64-libraries/winpthreads` directory of cloned `mingw-w64` repository.
