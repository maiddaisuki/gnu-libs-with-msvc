# Build GNU Packages with MSVC Tools

This repository contains two shell scripts:

- `libs-with-msvc.sh`
- `progs-with-msvc.sh`

which are used to automate building of software packages.

The main goal is to simplify build of GNU Libraries such as `libiconv` and
`libintl` with MSVC tools. But scripts' usage is not limited to that.

In addition to already supported packages, it should be easy to add support for
more packages. Please read [BUILD.md](./BUILD.md) and
[templates/README.md](./templates/README.md) for details.

The `libs-with-msvc.sh` is used to build libraries alone, while
`progs-with-msvc.sh` is used to optionally build programs after libraries
are built.

Please read [Building Porgrams](./BUILD.md#building-programs) in `BUILD.md`
before running `progs-with-msvc.sh` for details.

## Requirements

Run the scripts from either:

- [Cygwin](https://www.cygwin.com/)
- [Msys2](https://www.msys2.org/)

When using `Msys2` make sure you have `cygpath` package installed or install
it with

```shell
pacman -S cygpath
```

The scripts also make use of `which` tool. Make sure it is installed as well.

First, you need `Visual Studio` installtion. You do not need
the IDE, just `Build Tools for Visual Studio` will do.

Second, you need following build tools:

- `make`
- `automake` (provides `compile` and `ar-lib` wrappers for MSVC tools)
- `CMake`
- `Meson`
- `Ninja`

Please, keep in mind that if you install `CMake`, `Meson` and `Ninja` from
`Msys2`, you should install `mingw-w64-*-{cmake,meson,ninja}` packages and not
plain `cmake`, `meson` and `ninja` packages.

Oh the other hand, you should install plain `make` and not `mingw-w64-*-make`.

Cygwin's `CMake`, `Meson` and `Ninja` won't work. They must be native tools.

Visual Studio's `CMake` and `Ninja` work well, but you still might need `Meson`.

## Running

Run the scripts directly from the source tree:

```shell
./libs-with-msvc.sh [OPTIONS]
```

Some details are given in [BUILD.md](./BUILD.md).

### Common Options

Following options are accepted by both `libs-with-msvc.sh` and
`progs-with-msvc.sh`:

- `--debug`: link against debug version of CRT  
  see [Debug](./BUILD.md#debug) in `BUILD.md`
- `--env=FILENAME`: see [Environment](./BUILD.md#environment) in `BUILD.md`
- `--host=HOST`: value to pass with `configure`'s `--host` option  
  (by default `x86_64-w64-mingw32` is used)
- `--legacy`: see [Legacy](./BUILD.md#legacy) in `BUILD.md`
- `--llvm`: use LLVM tools (`clang-cl.exe`) instead of MSVC tools (`cl.exe`)
- `--static`: build only static libraries and link against static CRT  
  see [STATIC.md](/STATIC.md) for details

### `libs-with-msvc.sh`'s options

The `libs-with-msvc.sh` accepts following command line options:

- `--disable-stage1`: disable stage 1 of the build
- `--disable-stage2`: disable stage 2 of the build

Please see [Ncurses](./packages/README.md#ncurses) in `packages/README.md`
for details about following options:

- `--ncurses-workaround`
- `--ncurses-static`

### `progs-with-msvc.sh`'s options

The `libs-with-msvc.sh` accepts following command line options:

- `--with-autotools`: configure and install `autoconf`, `automake` and `libtool`.

## Source Tree Structure

Most of subdirectories contain supporting scripts which are sourced with `.`
command.

### `config/`

This subdirectory contains files intended to be modified by user to customize
the build process, for example:

- add compiler flags with `CFLAGS` and `CXXFLAGS`
- specify source and build directories
- select optional packages to build

See [config/README.md](./config/README.md) for details.

### `include/`

This subdirectory contains support scripts.

See [include/README.md](./include/README.md) for details.

### `packages/`

This subdirectory contains scripts to build specific packages.

See [packages/README.md](./packages/README.md) for details.

### `templates/`

This subdirectory contains template script for new packages.

See [templates/README.md](./templates/README.md) for details.
