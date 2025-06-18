# include/README.md

This subdirectory contains support scripts.

These scripts are sourced with `.` rather than executed.

## Files

### Build System-Specific Functions

The `make.sh`, `meson.sh` and `cmake.sh` define generic functions for
`GNU Autotools`, `Meson` and `CMake` based packages.

The `stage_vars.sh` defines the `stage_vars` function which is used by
`_{cmake|make|meson}_main` functions to help set stage-specific variables
like `prefix` and `builddir`.

### Stage-Specific Variables

The `stageN.sh` scripts are used to adjust values of variables like
`PATH`, `CMAKE_PREFIX_PATH` and `PKG_CONFIG_LIBDIR` for the current stage.

The `N` is `1` and `2` for `libs-with-msvc.sh`.  
The `N` is `3` for `progs-with-msvc.sh`.

The `tools.sh` is sources by `stageN.sh` to adjust library and include
search paths and set variables used with `configure` scripts.

### Other Files

The `verify.sh` is used to ensure that non-optional dependencies of optional
packages are requested to be built. In addition, it also handles `--debug` and
`--static` options.

The `post_instll.sh` defines `post_install` function which performs some
post-installation actions. In particular it patches `*.la` and `*.pc` files
to have native windows directory names.

The `devenv.sh` defines `devenv` function which writes script named
`${PREFIX}/devenv.sh`. This script may be sourced

```shell
. ${PREFIX}/devenv.sh
```

to set varaibles like `PATH`, `CMAKE_PREFIX_PATH` and `PKG_CONFIG_LIBDIR`
to include `PREFIX`.
