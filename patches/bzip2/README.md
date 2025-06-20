# meson.build for bzip2

This subdirectory contains `meson.build` which allows to build `bzip2`
using `Meson` build system.

## Building

Copy `meson.build` to the root of `bzip2`'s source tree.

You need to modify file `libbz2.def`: prepend the first two lines with `;`,
or simply remove them.

You may also need to change value of `version` keyword in `project` call.
Current value is `1.0.8`.

## Targets

This `meson.build` defines the following targets:

- `bz2` library
- `bzip2` executable
- `bzip2recover` executable

### Using as Subproject

This `meson.build` declares dependency object `libbz2_dep` to link with `libbz2`
when used as a subproject.
