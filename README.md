# Build Packages with MSVC Tools

The `msvc-build.sh` is a shell script to simplify building of software
packages with MSVC tools.

## Getting Started

You should run the script from one of the following environments:

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

## Running the Script

See [BUILD.md](/BUILD.md) for details on how to run `msvc-build.sh`.

## Supported Packages

See [PACKAGES.md](/PACKAGES.md) for information about supported packages.

## Build Options

The `config` subdirectory contains configs intended to be modified by user.

You must set `PREFIX`, `SRCDIR` and `BUILDDIR` in `config/dirs.sh`.

You can modify build options in `config/options.sh`. For example, you may
set `ENABLE_STATIC=true` to build static libraries.

You can select packages to build in `config/packages.sh`. You need to set
`*_SRCDIR` in `config/dirs.sh` for each selected package.

You can add compiler and linker flags in `config/flags.sh`.

## Adding New Packages

In addition to already supported packages, it should be easy to add support for
more packages.

See [BUILD.md](./BUILD.md) and [templates/TEMPLATES.md](./templates/TEMPLATES.md)
for details.
