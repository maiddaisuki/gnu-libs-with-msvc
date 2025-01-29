# meson.build for winpthreads

This subdirectory contains [meson.build](./meson.build) which allows to build
[mingw-w64's](https://www.mingw-w64.org) `winpthreads` library
using `Meson` build system.

## Targets

This `meson.build` file defines to targets: `pthread` and `winpthreads`.
The are the same library.

The `pthread` target will be built when the project is build on its own.
When installed, it will work with the usual `-lpthread` linker flag.

The `winpthreads` will be built and used when the package is built as
a **subproject**.

### Using as Subproject

This `meson.build` declares one dependency object `winpthreads_dep`.

It allows to use `winpthreads` as a fallback when special dependency `threads`
was not found for native windows build (e.g. with MSVC tools).

```meson
threads = dependency('threads', required: false)

if not threads.found()
  if meson.system() == 'windows'
    threads = subproject('winpthreads').get_variable('winpthreads_dep')
  else
    # try to find other threads library
	  # or
    # error out
	  # or
	  # threads = disabler()
  endif
endif
```
