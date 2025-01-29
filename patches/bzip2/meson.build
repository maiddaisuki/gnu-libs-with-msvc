
# meson.build for bzip2

project(
  'bzip2',
  'c',

  version: '1.0.8',
  # current meson version for Debian 12 is 1.0.1
  meson_version: '>=1.0.0',

  # a dictionary can be used only since 1.2.0
  default_options: [
    'buildtype=release',
    'b_ndebug=if-release'
  ]
)

fs = import('fs')

# global stuff

project_arguments = ['-D_FILE_OFFSET_BITS=64']

if host_machine.system() == 'windows'
  # I am unsure whether it is really needed, but this is what makefile.msc does
  project_arguments += ['-DWIN32']
endif

add_project_arguments(
  project_arguments,
  language: 'c'
)

include = include_directories('.')

# libbz2

libbz2_version = meson.project_version().split('.')

libbz2_sources = files(
  'blocksort.c',
  'huffman.c',
  'crctable.c',
  'randtable.c',
  'compress.c',
  'decompress.c',
  'bzlib.c'
)

libbz2_headers = files(
  'bzlib.h'
)

libbz2_kwargs = {}

if host_machine.system() in ['windows', 'cygwin']
  libbz2_def = files('libbz2.def')

  libbz2_kwargs += {
    'soversion': libbz2_version[0],
    'vs_module_defs': libbz2_def[0]
  }
else
  # Makefile-libbz2_so uses both major and minor parts in soname
  libbz2_kwargs += {
    'soversion': '@0@.@1@'.format(libbz2_version[0], libbz2_version[1])
  }
endif

libbz2 = library(
  'bz2',
  libbz2_sources,

  version: meson.project_version(),
  include_directories: include,

  install: true,

  kwargs: libbz2_kwargs
)

libbz2_dep = declare_dependency(
  link_with: libbz2,
  include_directories: include
)

# bzip2

bzip2_sources = files(
  'bzip2.c'
)

bzip2 = executable(
  'bzip2',
  bzip2_sources,

  dependencies: libbz2_dep,

  install: true
)

# bzip2recover

bzip2recover_sources = files(
  'bzip2recover.c'
)

bzip2recover = executable(
  'bzip2recover',
  bzip2recover_sources,

  dependencies: libbz2_dep,

  install: true
)

# installation

install_headers(
  libbz2_headers
)

# Arrays below declared as follows:
#
# [0] of each element is the name of a file installed to `*dir`
# [1] is list of symbolic links to create pointing to [0]

# bzip2 or bzip2.exe
bzip2_executable_name = fs.name(bzip2.full_path())

bzip2_bin = [
  [
    bzip2_executable_name,
    [
      bzip2_executable_name.replace('bzip2', 'bunzip'),
      bzip2_executable_name.replace('bzip2', 'bzcat')
    ]
  ]
]

foreach exe : bzip2_bin
  foreach alias : exe[1]
    install_symlink(
      alias,
      pointing_to: exe[0],

      install_tag: 'runtime',
      install_dir: get_option('bindir'),
    )
  endforeach
endforeach

bzip2_scripts = [
  [ 'bzgrep', [ 'bzegrep', 'bzfgrep' ] ],
  [ 'bzmore', [ 'bzless' ] ],
  [ 'bzdiff', [ 'bzcmp' ] ]
]

foreach exe : bzip2_scripts
  install_data(
    exe[0],

    install_tag: 'runtime',
    install_dir: get_option('bindir'),
    install_mode: [ 'rwxr-xr-x', 0, 0 ]
  )

  foreach alias : exe[1]
    install_symlink(
      alias,
      pointing_to: exe[0],

      install_dir: get_option('bindir')
    )
  endforeach
endforeach

bzip2_man1 = [
  [ 'bzip2.1', [] ],
  [ 'bzgrep.1', [ 'bzegrep.1', 'bzfgrep.1' ] ],
  [ 'bzmore.1', [ 'bzless.1' ] ],
  [ 'bzdiff.1', [ 'bzcmp.1' ] ]
]

foreach man : bzip2_man1
  install_man(
    man[0],

    install_dir: get_option('mandir') / 'man1',
    install_mode: [ 'rw-r--r--', 0, 0 ]
  )

  foreach alias : man[1]
    install_symlink(
      alias,
      pointing_to: man[0],

      install_tag: 'man',
      install_dir: get_option('mandir') / 'man1'
    )
  endforeach
endforeach

# tests

if build_machine.system() in [ 'windows', 'cygwin' ]
  diff = find_program('cmp', required: false)

  if not diff.found()
    diff = find_program('fc', required: true)
  endif
else
  diff = find_program('cmp', required: true)
endif

# TODO: tidy up mess below

samples = [
  [ '-1', files('sample1.ref', 'sample1.bz2'), 'sample1.rb2', 'sample1.tst' ],
  [ '-2', files('sample2.ref', 'sample2.bz2'), 'sample2.rb2', 'sample2.tst' ],
  [ '-3', files('sample3.ref', 'sample3.bz2'), 'sample3.rb2', 'sample3.tst' ],
]

compressed_files = []
decompressed_files = []

foreach sample : samples
  compressed_files += custom_target(
    command: [bzip2, sample[0]],
    build_by_default: false,

    input: sample[1][0],
    feed: true,

    output: sample[2],
    capture: true
  )

  decompressed_files += custom_target(
    command: [bzip2, '-d'],
    build_by_default: false,

    input: sample[1][1],
    feed: true,

    output: sample[3],
    capture: true
  )
endforeach

foreach i : [0, 1, 2]
  test(
    'compress-@0@'.format(i + 1),
    diff,
    args: [
      samples[i][1][1],
      compressed_files[i]
    ],

    suite: 'default'
  )

  test(
    'decompress-@0@'.format(i + 1),
    diff,
    args: [
      samples[i][1][0],
      decompressed_files[i]
    ],

    suite: 'default'
  )
endforeach
