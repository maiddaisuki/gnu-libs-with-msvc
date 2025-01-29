
# meson.build for mingw-w64's winpthreads

project(
  'winpthreads',
  'c',

  version: '1.0',
  meson_version: '>=1.3.0',

  default_options: {
    'buildtype': 'release',
    'b_ndebug': 'if-release',
    'c_std': 'gnu89,c89'
  }
)

windows = import('windows')

includes = include_directories('include')
includes_private = include_directories('src')

headers = files(
  'include/pthread.h',
  'include/pthread_compat.h',
  'include/pthread_signal.h',
  'include/pthread_time.h',
  'include/pthread_unistd.h',
  'include/sched.h',
  'include/semaphore.h'
)

sources = files(
  'src/barrier.c',
  'src/cond.c',
  'src/misc.c',
  'src/mutex.c',
  'src/rwlock.c',
  'src/spinlock.c',
  'src/thread.c',
  'src/ref.c',
  'src/sem.c',
  'src/sched.c',
  'src/clock.c',
  'src/nanosleep.c'
)

rc = windows.compile_resources(
  'src/version.rc',

  include_directories: includes_private
)

pthread_kwargs = {
  'c_args': ['-DIN_WINPTHREAD'],
  'c_shared_args': ['-DDLL_EXPORT'],

  'include_directories': includes,
  'sources': rc,

  'version': meson.project_version(),
  'soversion': meson.project_version().split('.')[0]
}

winpthreads = library(
  'winpthreads',
  sources,

  build_by_default: meson.is_subproject(),
  install: meson.is_subproject(),

  kwargs: pthread_kwargs
)

winpthreads_dep = declare_dependency(
  link_with: winpthreads,
  include_directories: includes
)

pthread = library(
  'pthread',
  sources,

  build_by_default: not meson.is_subproject(),
  install: not meson.is_subproject(),

  kwargs: pthread_kwargs
)

install_headers(
  headers
)

# tests

if meson.is_subproject()
  test_library = winpthreads
else
  test_library = pthread
endif

pthread_objects = test_library.extract_all_objects(recursive: false)
tests_kwargs = {
  'include_directories': includes,
  'objects': pthread_objects
}

tests = []

tests += executable('t_clock_getres', 'tests/t_clock_getres.c', kwargs: tests_kwargs)
tests += executable('t_clock_gettime', 'tests/t_clock_gettime.c', kwargs: tests_kwargs)
tests += executable('t_clock_nanosleep', 'tests/t_clock_nanosleep.c', kwargs: tests_kwargs)
tests += executable('t_clock_settime', 'tests/t_clock_settime.c', kwargs: tests_kwargs)
tests += executable('t_nanosleep', 'tests/t_nanosleep.c', kwargs: tests_kwargs)

foreach test : tests
  test(test.name(), test)
endforeach
