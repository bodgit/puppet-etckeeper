# @!visibility private
class etckeeper::config {

  $avoid_commit_before_install = $::etckeeper::avoid_commit_before_install
  $avoid_daily_autocommits     = $::etckeeper::avoid_daily_autocommits
  $avoid_special_file_warning  = $::etckeeper::avoid_special_file_warning
  $bzr_commit_options          = $::etckeeper::bzr_commit_options
  $conf_dir                    = $::etckeeper::conf_dir
  $darcs_commit_options        = $::etckeeper::darcs_commit_options
  $git_commit_options          = $::etckeeper::git_commit_options
  $git_user_email              = $::etckeeper::git_user_email
  $git_user_name               = $::etckeeper::git_user_name
  $hg_commit_options           = $::etckeeper::hg_commit_options
  $highlevel_package_manager   = $::etckeeper::highlevel_package_manager
  $lowlevel_package_manager    = $::etckeeper::lowlevel_package_manager
  $push_remotes                = $::etckeeper::push_remotes
  $vcs                         = $::etckeeper::vcs

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

  if ($vcs == 'git') and ($::osfamily == 'Debian') {
    $init_command = "etckeeper init;git config --local user.name ${git_user_name};git config --local user.email ${git_user_email}"
  }
  else {
    $init_command = 'etckeeper init'
  }

  exec { 'etckeeper init':
    command => $init_command,
    creates => $vcs_to_directory[$vcs],
    path    => $::path,
    require => File["${conf_dir}/etckeeper.conf"],
  }

}
