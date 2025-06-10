# Build GNU Packages with MSVC Tools

This repository contains two shell scripts:

- `libs-with-msvc.sh`
- `progs-with-msvc.sh`

These scripts are used to automate building of software packages.

The main goal is to simplify building of packages such as `libiconv` and
`libintl` with MSVC tools. But scripts' usage is not limited to that.

The `libs-with-msvc.sh` is used to build libraries alone, while
`progs-with-msvc.sh` is used to optionally build programs after libraries
are built.

## Getting Started

You should run the scripts from one of the following environments:

- [Cygwin](https://www.cygwin.com/)
- [Msys2](https://www.msys2.org/)

First, you need `Visual Studio` installtion. You do not need the IDE,
just `Build Tools for Visual Studio` will do.

Second, you need the following build tools:

- `make`
- `automake` (for `compile` and `ar-lib` wrappers)
- `cmake`
- `meson`
- `ninja`

Please, keep in mind that if you install `cmake`, `meson` and `ninja` from
`Msys2`, you should install `mingw-w64-*-{cmake,meson,ninja}` packages and not
plain `cmake`, `meson` and `ninja` packages.

Oh the other hand, you should install plain `make` and not `mingw-w64-*-make`.

Cygwin's `cmake`, `meson` and `ninja` won't work. They must be native tools.

Visual Studio's `cmake` and `ninja` work well, but you still might need `meson`.

### Running Scripts

See [BUILD.md](/BUILD.md) for details.

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

This subdirectory contains template scripts for new packages.

See [templates/README.md](./templates/README.md) for details.

## Adding New Packages

In addition to already supported packages, it should be easy to add support for
more packages.

See [BUILD.md](./BUILD.md) and [templates/README.md](./templates/README.md)
for details.
