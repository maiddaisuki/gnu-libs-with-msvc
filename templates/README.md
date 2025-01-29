# templates/README.md

This subdirectory contains build system-specific templates for new packages.

The `make.sh`, `meson.sh` and `cmake.sh` are used respectively for
`GNU Autotools`, `Meson` and `CMake` based packages.

The `make.sh` may also be used for packages following `GNU Makefile conventions`.
However, it must work with MSVC tools, which is usually not the case.

When packages supports multiple build systems, the precedance is as follows:

- `Meson`
- `CMake`
- `GNU Autotools`

You may write multiple scripts for multiple build systems if you wish. If
package supports `GNU Autotools` name that script as `{package}.sh` and others
as `{package}.meson.sh` or `{package}.cmake.sh`.

`Meson` is generally preferred over `CMake`, but it is not a requirement.

## Writing {package}\_configure Function

The default template for `{package}_configure` function only passes options
controlled by the scripts. You will need to adjust them to pass package-specific
options either to `configure` or the build system.

The `WITH_{package}` variables from [packages.sh](/config/packages.sh) may be
used to conditionally pass options which control linking to optional libraries.

If a package supports an optional library which is not yet supported, add it to
`packages.sh` and simply set it to `false` and use this variable in the
`{package}_configure`. Add condition to `verify.sh` to error out if this
unsupported package is requested.
