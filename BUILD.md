# BUILD.md

This file describes effect of some options on the build process.

## Build Stages

The `libs-with-msvc.sh` internally has two build stages.

The first stage is used to build some libraries and programs needed in stage 2.

The second stage in when all libraries are actually built.

As of now, the first stage is used to:

- build `libiconv` and `libintl`  
  This is done to resolve circular dependency: `libintl` depends on `libiconv`,
  while `libiconv` has optional dependency on `libintl`.
- build and install `libtool` script  
  It is used to build `ncurses` unless `--ncurses-static` is passed

Each stage may be disabled with `--disable-stage1` and `--disable-stage2`
options.  
These options are intended to aid debugging and testing the script.

## Linking Against Static CRT

The `--static` option.

When `--static` option is passed, the scripts arrange to pass required options
to the build system or, in case of `configure`, compiler flags to link
against static version of CRT.

## Debug

The `--debug` option.

When `--debug` option is passed, the scripts arrange to pass required options
to the build system to link against debug verions of CRTs.

## Interaction between `--debug` and `--static`

The following tables summarize which compiler options and build system
options are passed depending on state of `--debug` and `--static` options.

For `configure`:

|         | default               | --static              |
| ------- | --------------------- | --------------------- |
| default | C[XX]FLAGS=`-MD -O2`  | C[XX]FLAGS=`-MT -O2`  |
| --debug | C[XX]FLAGS=`-MDd -Od` | C[XX]FLAGS=`-MTd -Od` |

For `CMake` two variables are affected:

- `CMAKE_BUILD_TYPE`
- `CMAKE_MSVC_RUNTIME_LIBRARY`

The `CMAKE_BUILD_TYPE` is set as follows:

|         | default | --static |
| ------- | ------- | -------- |
| default | Release | Release  |
| --debug | Debug   | Debug    |

The `CMAKE_MSVC_RUNTIME_LIBRARY` is set as follows:

|         | default               | --static           |
| ------- | --------------------- | ------------------ |
| default | MultiThreadedDLL      | MultiThreaded      |
| --debug | MultiThreadedDebugDLL | MultiThreadedDebug |

For `Meson`:

|         | default                          | --static                         |
| ------- | -------------------------------- | -------------------------------- |
| default | --buildtype release -Db_vscrt=md | --buildtype release -Db_vscrt=mt |
| --debug | --buildtype debug -Db_vscrt=mdd  | --buildtype debug -Db_vscrt=mtd  |

## Legacy

The `--legacy` options.

The scripts assumes you use at least `Visual Studio 2017`.  
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

## Building Programs

Details about `progs-with-msvc.sh`.

Not many packages are supported yet, and in most cases it is easier to install
them from `Msys2` or `Cygwin`. More packages may be added later and this script
will be more useful.

I plan to add support for building `pkg-config` and `pkgconf`. I think this is
the most useful programs this script may build.

### Autotools

Original idea was to allow build common GNU development tools, this includes:

- `autoconf` (needs `m4`)
- `automake` (needs `perl`)
- `bison` (depends on `m4`)
- `gettext`
- `libtool` (needs `m4`)
- `m4`
- `make`

The natively built `m4` and `bison` do not seem to function well:

- `m4`'s testsuite seems to fail a lot.
- `bison`'s testsuite fails completely.

The `Autoconf`, `Automake` and `Libtool` may be configured and installed by
passing `--with-autotools` option. Keep in mind that `Autoconf` and `Libtool`
are shell scripts and cannot be "native". `Automake` is a `perl` script and
I am unsure if it works with natively built `perl`.

I did not try to build `make` and `perl` with MSVC tools. Also, natively built
`make` will not work with `Autotools`.
