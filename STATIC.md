# Static Libraries and MSVC

By default, the script will build only shared libraries.
You may request build of static libraries by setting `ENABLE_STATIC=true` in
[config/options.sh](/config/options.sh). Also, by default the script will link
against shared version of CRT.

You may also use `--static` option to:

- disable build of shared libraries
- enable build of static libraries
- link against static version of CRT

This documents explains some details and the reasoning for the default choice.

## Shared and Static CRT

By default, `cl.exe` links against static version of CRT (as if `-MT` was used).
This means that every iamge contains its own version of CRT.
As the result, global state such as locale, open `FILE` objects, `errno` value,
memory allocations, etc. are local to each such image.

On the other hand, `-MD` option makes `link.exe` link against shared version of
CRT. All iamges use the same shared version of CRT.
Global state is shared among all such images within a process.

The `-MT` and `-MD` do not affect code generation unlike common options
such as `-fPIC` and `-fPIE`. They simply store name of CRT library to link
against in object files.

The `-MD` option also defines `_DLL` preprocessor macro used by system
header files to decorate symbols with `__declspec(dllimport)`.

Mixing object files compiled with `-MT` and `-MD` is possible but strongly
discouraged.

## Interaction Between Static and Shared Libraries

Interaction between static and shared libraries may be surprising.

Keep in mind the following:

- when you build shared version of a library you need to decorate exported
  functions and variables with `__declspec(dllexport)`
- when you build static version you should not decorate them

Now, consider the following case:

- There are two libraries: `liba` and `libb`, and `libb` depends on `liba`
- Both have static and shared version
- You want to:
  1. link against static `libb` but shared `liba`
  2. link against shared `libb` but static `liba`

On Windows, the outcome of two cases above depends on how static `libb` was
build: were `liba`'s symbols decorated with `__declspec(dllimport)` or not?

If `libb` is referencing decorated symbols from `liba`

- linking against static `liba` will fail, since symbols in static `liba`
  were not decorated with `__declspec(dllexport)` when it was built
- linking against shared `liba` will succeed

If `libb` is referencing undecorated symbols from `liba`

- linking against static `liba` will succeed
- linking against shared `liba` will succeed, however if `libb` references
  any exported variable from `liba`, it will most likely cause crash at runtime

On Linux, you would simply do something like this:

```shell
gcc ... -Wl,--push-state,-static,-lb,--pop-state -la
```

or

```shell
gcc ... -lb -Wl,--push-state,-static,-la,--pop-state
```

You do not have to care about `__declspec()`.

### Possible Solutions

In most cases, we would want to do the following:

- When building a shared library, link it against shared libraries:
  we want header files of libraries we link against to decorate their symbols
  with `__declspec(dllimport)`
- When building a static library, _link_ it against static libraries:
  we want header files of libraries we link against to omit
  `__declspec(dllimport)` from declarations

This way, static libraries will not have references to decorated symbols in
libraries they depond on.

Currently none of `libtool`, `cmake` and `meson` provide a way to accomplish
this. When you build `libb`, both static and shared version will reference
the same kind of symbols from `liba`.

Take another example: You want to embed a static library into an executable
or a shared library

In this case "link static against static" may not work.
If both executable/library and static library in question share the same
dependency, you may want them to use the shared version of it. If static library
references undecorated symbols of that dependency, you may get improperly
imported variables which will result in crash at runtime.

Unless you have a special case like above example and you can control what kind
of library is used during the compilation and linking, it is strongly encouraged
to build only shared or static libraries, not both at the same time.
