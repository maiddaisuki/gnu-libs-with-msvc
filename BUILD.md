# BUILD.md

This file describes how to run `libs-with-msvc.sh` and `progs-with-msvc.sh`.

## Invocation

Run the scripts directly from the source tree:

```shell
./libs-with-msvc.sh [OPTIONS]
```

### Options

`libs-with-msvc.sh` and `progs-with-msvc.sh` accept the following options:

- `--buildtype=BUILDTYPE`: controls optimizations and
  generation of debug information
- `--debug`: link against debug version of CRT
- `--env=FILENAME`
- `--host=HOST`: value to pass with `configure`'s `--host` option
  (by default `x86_64-w64-mingw32` is used)
- `--legacy`: support older versions of build tools
- `--llvm`: use LLVM tools instead of MSVC tools
- `--static`: build only static libraries and link against static version of CRT

See below for more details on each option.

The `libs-with-msvc.sh` also accepts the following options:

- `--disable-stage1`: disable stage 1 of the build
- `--disable-stage2`: disable stage 2 of the build

### Building Programs (`progs-with-msvc.sh`)

Not many packages are supported yet, and in most cases it is easier to install
them from `Msys2` or `Cygwin`. More packages may be added in the future.

## Linking Against Debug Version of CRT

The `--debug` option.

When `--debug` option is passed, the scripts will pass required options
to the build systems to link against debug verion of CRT.

This option is useful if you're building debug versions of you projects with
`-MDd` or `-MTd` options. Note that you should not mix object files and
libraries compiled for different flavors of CRT (e.g. debug vs non-debug).

## Linking Against Static Version of CRT

The `--static` option.

When `--static` option is passed, the scripts will pass required options
to the build systems to link against static version of CRT.

See [STATIC.md](/STATIC.md) for more details.

## Build Type

The `--buildtype=BUILDTYPE` option.  
This option controls optimizations and generation of debug information.

The following table list supported values for `BUILDTYPE` and compiler/linker
flags used:

| Value         | CPPFLAGS | C[XX]FLAGS   | LDFLAGS  |
| ------------- | -------- | ------------ | -------- |
| release       | -DNDEBUG | -O2 -Ob2     | -release |
| small-release | -DNDEBUG | -O1 -Ob1     | -release |
| debug         |          | -Od -Ob0 -Z7 | -debug   |

When buildtype is `debug`, object files will be compiled with `-Z7`, which will
store debug info in object files. Note, however, that `.pdb` files will only be
generated if `-debug` option is passed to the linker.

## Older Versions of Tools

The `--legacy` options.

The scripts assumes that you use at least `Visual Studio 2017`.  
By default, they will pass extra flags to `configure` scripts.

`CFLAGS`:

- `-std:c17` to request C17 language support
- `-Zc:__STDC__` to define `__STDC__` to `1`

`CXXFLAGS`:

- `-std:c++20` to request C++20 language support
- `-Zc:__cplusplus` so that `__cplusplus` macro correctly reports C++ version

`CPPFLAGS`:

- `-D_CRT_DECLARE_NONSTDC_NAME` to expose "non-conforming/deprecated"
  POSIX names in Microsoft header files  
  (this reverts an effect of `-Zc:__STDC__`)

Passing `--legacy` option prevents usage of these flags.

## Environment

The `--env` option.

In order to use `Visual Studio` tools from shell we need to correctly set
environment variables like `LIB`, `INCLUDE` and `PATH`.

This repository has [vs2sh](https://www.github.com/maiddaisuki/vs2sh)
as a submodule.  
Fetch it if you didn't and read `vs2sh/README.md` for more information.

By default `vs2sh.sh` produces file named `vs.sh`. This is the default file
the scripts attempt to read.  
Use `--env` option to specify a different file.

## Internals

### Build Stages

The `libs-with-msvc.sh` internally has two build stages.

The first stage is used to build some libraries and programs needed in stage 2.

The second stage in when all libraries are actually built.

As of now, the first stage is used to:

- build `libiconv` and `libintl`  
  This is done to resolve circular dependency: `libintl` depends on `libiconv`,
  while `libiconv` has optional dependency on `libintl`.
- configure and install `libtool` script  
  Installed `libtool` script is used to build `ncurses`

Each stage may be disabled with `--disable-stage1` and `--disable-stage2`
options.  
These options are intended to aid debugging and testing the script.
