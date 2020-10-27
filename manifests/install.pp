# @!visibility private
class etckeeper::install {

  # if RedHat, need to have EPEL installed
  if $::osfamily == 'RedHat' {
    include ::epel
    Class['::epel'] -> Package[$::etckeeper::package_name]
  }
  package { $::etckeeper::package_name:
    ensure => present,
  }

  if $etckeeper::manage_vcs_package {
    if has_key($etckeeper::vcs_packages, $etckeeper::vcs) {
      package { $etckeeper::vcs_packages[$etckeeper::vcs]:
        ensure  => present,
        require => Package[$etckeeper::package_name],
      }
    } else {
      fail("No package available for VCS ${etckeeper::vcs}.")
    }
  }
}
