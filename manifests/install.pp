# @!visibility private
class etckeeper::install {

  package { $::etckeeper::package_name:
    ensure => present,
  }

  if has_key($::etckeeper::vcs_packages, $::etckeeper::vcs) {
    ensure_packages([$::etckeeper::vcs_packages[$::etckeeper::vcs]], {
      require => Package[$::etckeeper::package_name],
    })
  } else {
    fail("No package available for VCS ${::etckeeper::vcs}.")
  }
}
