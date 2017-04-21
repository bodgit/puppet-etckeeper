# @!visibility private
class etckeeper::config {

  $avoid_commit_before_install = $::etckeeper::avoid_commit_before_install
  $avoid_daily_autocommits     = $::etckeeper::avoid_daily_autocommits
  $avoid_special_file_warning  = $::etckeeper::avoid_special_file_warning
  $bzr_commit_options          = $::etckeeper::bzr_commit_options
  $conf_dir                    = $::etckeeper::conf_dir
  $darcs_commit_options        = $::etckeeper::darcs_commit_options
  $git_commit_options          = $::etckeeper::git_commit_options
  $hg_commit_options           = $::etckeeper::hg_commit_options
  $highlevel_package_manager   = $::etckeeper::highlevel_package_manager
  $lowlevel_package_manager    = $::etckeeper::lowlevel_package_manager
  $push_remotes                = $::etckeeper::push_remotes
  $vcs                         = $::etckeeper::vcs
  $vcs_user_email              = $::etckeeper::vcs_user_email
  $vcs_user_name               = $::etckeeper::vcs_user_name

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { "${conf_dir}/etckeeper.conf":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/etckeeper.conf.erb"),
  }

  $vcs_to_directory = {
    'bzr'   => '/etc/.bzr',
    'darcs' => '/etc/_darcs',
    'git'   => '/etc/.git',
    'hg'    => '/etc/.hg',
  }

  $vcs_to_directory.each |$_vcs,$directory| {

    if $vcs != $_vcs {
      file { $directory:
        ensure => absent,
        force  => true,
        before => Exec['etckeeper init'],
      }
    }
  }

  exec { 'etckeeper init':
    creates => $vcs_to_directory[$vcs],
    path    => $::path,
    require => File["${conf_dir}/etckeeper.conf"],
  }

  case $vcs {
    'git': {
      file { '/etc/.git/config':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        require => Exec['etckeeper init'],
      }

      if $vcs_user_name and $vcs_user_email {
        ini_setting { '/etc/.git/config user.name':
          ensure  => present,
          path    => '/etc/.git/config',
          section => 'user',
          setting => 'name',
          value   => $vcs_user_name,
        }

        ini_setting { '/etc/.git/config user.email':
          ensure  => present,
          path    => '/etc/.git/config',
          section => 'user',
          setting => 'email',
          value   => $vcs_user_email,
        }
      }
    }
    default: {
      # noop
    }
  }
}
