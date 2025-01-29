# Static Libraries and MSVC

By default, the scripts will build only shared libraries.

You may request build of static libraries by setting `ENABLE_STATIC=true` in
[config/options.sh](/config/options.sh).

Also, by default the scripts will link against shared version of CRT
(with `-MD` compiler option).

The `--static` option tells the scripts to:

- disable build of shared libraries
- enable build of static libraries (regardless of value of `ENABLE_STATIC`)
- link against static version of CRT (`-MT` compiler option)

This documents explains some details and the reasoning for default choice.

## Shared and Static CRT

By default, `cl.exe` links with static version of CRT (as if `-MT` was used).

This means that every executable and DLL contains its own version of CRT.
Think of it as if you would staticly `-lc` into them. This results in whole lot
of issues.

On the other hand, `-MD` option makes `link.exe` link agains shared version of
CRT.  
This is what we normally want: all programs and libraries use the same shared
version of the C Library.

Also keep in mind that there is no way to link Microsoft's C++ Library staticly.

The `-MT` and `-MD` do not affect code generation unlike common `gcc` options
such as `-fPIC` and `-fPIE`. They simply store name of CRT library to link
against in object files.

The `-MD` option also defines `_DLL` preprocessor macro used by system
header files to decorate functions with `declspec(dllimport)`.

Mixing object files compiled with `-MT` and `-MD` will likely make applications
crash at runtime, or worse result in hard-to-spot bugs.

### `-MT`

Since `-MT` links against static version of CRT it makes absolutely no sense
to build shared libraries with this option.

The `--static` option allows you to create static libraries and
applications linked against static version of CRT.

### `-MD`

This option tells `link.exe` to link against shared version of CRT.  
This is the way to go when we use shared libraries.

But interaction with static libraries compiled with `-MD` may be not as obvious.  
Think of this:

- when you build shared version of a library you need to decorate functions with
  `declspec(dllimport)`
- when you build static version you should not decorate functions

This not the issue.  
The issue may appear if try to mix shared and static libraries with
interdependencies.

#### Example

Imagine you have `liba` and `libb`.  
Both have static and shared version, and `libb` depends on `liba`.

Now, imagine you want to link against static version of `libb` but
shared version of `liba`.

On Linux, you could do this with something like this:

```shell
gcc ... -Wl,--push-state,-static,-lb,--pop-state -la
```

There is no need to think about `declspec(...)` interactions.

But when we built static `libb` on windows, what kind of symbols from `liba`
was used? Were they decorated with `declspec(...)` or not?

The obvious solution is to use non-decorated symbols when building the
static library.

#### Auto Import

While `declspec(dllexport)` must be used when building a shared library, the
`declspec(dllimport)` is optional when we link against shared library.

The `link.exe` will be able to resolve those function calls, however,
it comes at cost of one extra jump instruction at runtime.

`NOTE`: in order to access data objects (e.g. varaibles) from the DLL they still
must be declared with `declspec(dllimport)`.

So, for example, both

```shell
link.exe ... libb.lib liba.dll.lib
```

and

```shell
link.exe ... libb.lib liba.lib
```

will work if static `libb.lib` references non-decorated symbols from `liba`.
