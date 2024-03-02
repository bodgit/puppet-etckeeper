# @!visibility private
class etckeeper::install {

  package { $etckeeper::package_name:
    ensure => present,
  }

  if $etckeeper::manage_vcs_package {
    if $etckeeper::vcs in $etckeeper::vcs_packages {
      package { $etckeeper::vcs_packages[$etckeeper::vcs]:
        ensure  => present,
        require => Package[$etckeeper::package_name],
      }
    } else {
      fail("No package available for VCS ${etckeeper::vcs}.")
    }
  }
}
