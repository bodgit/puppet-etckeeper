
# @!visibility private
class etckeeper::params {

  $bzr_commit_options   = undef
  $conf_dir             = '/etc/etckeeper'
  $darcs_commit_options = '-a'
  $git_user_name        = 'etckeeper'
  $git_user_email       = 'root@localhost'
  $git_commit_options   = undef
  $hg_commit_options    = undef
  $package_name         = 'etckeeper'
  $vcs_packages         = {
    'bzr'   => 'bzr',
    'darcs' => 'darcs',
    'git'   => 'git',
    'hg'    => 'mercurial',
  }

  case $::osfamily {
    'RedHat': {
      $highlevel_package_manager = 'yum'
      $lowlevel_package_manager  = 'rpm'
      $vcs                       = 'git'
    }
    'Debian': {
      $highlevel_package_manager = 'apt'
      $lowlevel_package_manager  = 'dpkg'

      case $::operatingsystem {
        'Ubuntu': {
          case $::operatingsystemrelease {
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
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
