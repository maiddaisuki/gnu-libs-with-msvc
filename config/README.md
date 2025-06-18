# config/README.md

This subdirectory contains files intended to be modified by the user to
customize build process.

## Files

### `dirs.sh`

This file is used to set build, source and installation directories.

You should set following variables before running any script:

- `PREFIX`: installation prefix
- `SRCDIR`: root directory for relative `{package}_SRCDIR` directories
- `BUILDDIR`: directory to use as the build root
  (default is `${TEMP}`)

You alse need to set variables in format `{package}_SRCDIR`. Their values
may be both relative and absolute. Relative values will be appended to
`SRCDIR`.

Specify all directories as native windows paths with forward slashes,
e.g. `C:/some/dir`. The scripts will handle required conversions.

### `packages.sh`

This file allows to select optional packages to build.

It contains variables named `WITH_{PACKAGE}` which may be set to either
`true` or `false`.

### `options.sh`

This file allows to modify some aspects of the build process.

For example, you may set `ENABLE_STATIC=true` to build static libraries
in addition to shared libraries built by default.

See comments in [options.sh](./options.sh).

### `flags.sh`

This file allows to set custom compiler and linker flags.
