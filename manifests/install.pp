# @!visibility private
class etckeeper::install {

  # if RedHat, need to have EPEL installed
  if $::osfamily == 'RedHat' and ! $::etckeeper::assume_epel {
    if defined(Class['epel']) {
      Class['epel'] -> Package[$::etckeeper::package_name]
    }
    else {
      warning("Without EPEL repository configured, I probably won't be able to find package ${::etckeeper::package_name}.  See \$assume_epel for more information.")
    }
  }
  package { $::etckeeper::package_name:
    ensure => present,
  }

  if $::etckeeper::manage_vcs_package {
    if has_key($::etckeeper::vcs_packages, $::etckeeper::vcs) {
      package { $::etckeeper::vcs_packages[$::etckeeper::vcs]:
        ensure  => present,
        require => Package[$::etckeeper::package_name],
      }
    } else {
      fail("No package available for VCS ${::etckeeper::vcs}.")
    }
  }
}
