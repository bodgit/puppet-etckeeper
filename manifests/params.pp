# @!visibility private
class etckeeper::params {

  $bzr_commit_options   = undef
  $conf_dir             = '/etc/etckeeper'
  $darcs_commit_options = '-a'
  $git_commit_options   = undef
  $hg_commit_options    = undef
  $package_name         = 'etckeeper'
  $vcs_packages         = {
    'bzr'   => 'bzr',
    'darcs' => 'darcs',
    'git'   => 'git',
    'hg'    => 'mercurial',
  }

  case $facts['os']['family'] {
    'RedHat': {
      $highlevel_package_manager = 'yum'
      $lowlevel_package_manager  = 'rpm'
      $vcs                       = 'git'
    }
    'Suse': {
      $highlevel_package_manager = 'zypper'
      $lowlevel_package_manager  = 'rpm'
      $vcs                       = 'git'
    }
    'Debian': {
      $highlevel_package_manager = 'apt'
      $lowlevel_package_manager  = 'dpkg'

      case $facts['os']['name'] {
        'Ubuntu': {
          case $facts['os']['release']['full'] {
            '14.04': {
              $vcs = 'bzr'
            }
            default: {
              $vcs = 'git'
            }
          }
        }
        default: {
          $vcs = 'git'
        }
      }
    }
    'Archlinux': {
      $highlevel_package_manager = 'pacman'
      $lowlevel_package_manager  = 'pacman'
      $vcs                       = 'git'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${facts['os']['family']} based system.")
    }
  }
}
