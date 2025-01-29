# meson.build for bzip2

This subdirectory contains [meson.build](./meson.build) which allows to build
`libbz2` library using `Meson` build system.

## Targets

This `meson.build` difines following targets:

- `bz2` library
- `bzip2` executable
- `bzip2recover` executable

### Using as Subproject

This `meson.build` declares dependency object `libbz2_dep` to link with `libbz2`
when used as a subproject.
