# Add a glob pattern for the chosen VCS to ignore.
#
# @example Ignoring an example pattern
#   etckeeper::ignore { '*.foo':
#     ensure => present,
#   }
#
# @param ensure
# @param glob The pattern to ignore.
#
# @see puppet_classes::etckeeper etckeeper
#
# @since 1.2.0
define etckeeper::ignore (
  Enum['present', 'absent'] $ensure = 'present',
  String[1]                 $glob   = $title,
) {

  if ! defined(Class['etckeeper']) {
    fail('You must include the etckeeper base class before using any etckeeper defined resources')
  }

  $vcs = $::etckeeper::vcs

  case $vcs {
    'darcs': {
      # For darcs, convert the glob to a regex how etckeeper does it
      if $glob[0] == '*' {
        $start  = 1
        $prefix = '' # lint:ignore:empty_string_assignment
      } else {
        $start  = 0
        $prefix = '(^|/)'
      }
      if $glob[-1] == '*' {
        $end    = -2
        $suffix = '' # lint:ignore:empty_string_assignment
      } else {
        $end    = -1
        $suffix = '($|/)'
      }
      $_glob = suffix(prefix(regsubst(regsubst(regsubst($glob[$start, $end], '\.', '\\.', 'G'), '\*', '[^\\/]*', 'G'), '\?', '[^\\/]', 'G'), $prefix), $suffix)
    }
    'bzr': {
      # bzr doesn't need to excape anything
      $_glob = $glob
    }
    default: {
      # git and hg need to escape # characters
      $_glob = regsubst($glob, '#', '\\#', 'G')
    }
  }

  $vcs_ignore = {
    'bzr'   => '/etc/.bzrignore',
    'darcs' => '/etc/.darcsignore',
    'git'   => '/etc/.gitignore',
    'hg'    => '/etc/.hgignore',
  }

  # Relying on this to always append to the bottom of the file
  file_line { "${vcs_ignore[$vcs]} ${glob}":
    ensure  => $ensure,
    path    => $vcs_ignore[$vcs],
    line    => $_glob,
    require => Class['etckeeper::config'],
  }
}
