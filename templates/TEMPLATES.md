# Templates

This subdirectory contains template scripts.

The `make.sh`, `meson.sh` and `cmake.sh` are used for packages which use
`GNU Autotools`, `Meson` and `CMake` build system respectively.

When packages supports multiple build systems, the precedance is:

- `CMake`
- `Meson`
- `GNU Autotools`

You can write a script for each build system if you wish.
Name them `{package}.sh`, `{package}.meson.sh` and `{package}.cmake.sh`
for `GNU Autotools`, `Meson` and `CMake` respectively.

## Writing {package}\_configure Function

The default template for `{package}_configure` function only passes options
controlled by the scripts. You will need to adjust it to pass package-specific
options to the build system.

The `WITH_{package}` variables from [packages.sh](/config/packages.sh) may be
used to conditionally pass options which control linking to optional libraries.

If a package uses an optional library which is not yet supported, add it to
`packages.sh` and simply set it to `false`.
Update `verify.sh` to error out if this unsupported package is requested.
