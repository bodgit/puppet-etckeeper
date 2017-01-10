# Installs etckeeper.
#
# @example Declaring the class
#   include ::etckeeper
#
# @example Choosing a specific VCS instead of the default
#   class { '::etckeeper':
#     vcs => 'bzr',
#   }
#
# @param avoid_commit_before_install
# @param avoid_daily_autocommits
# @param avoid_special_file_warning
# @param bzr_commit_options
# @param conf_dir Top-level configuration directory, usually `/etc/etckeeper`.
# @param darcs_commit_options
# @param git_commit_options
# @param hg_commit_options
# @param highlevel_package_manager
# @param lowlevel_package_manager
# @param package_name The name of the package.
# @param push_remotes
# @param vcs
# @param vcs_packages Hash of VCS to the package that provides it.
class etckeeper (
  Optional[Boolean]                    $avoid_commit_before_install = undef,
  Optional[Boolean]                    $avoid_daily_autocommits     = undef,
  Optional[Boolean]                    $avoid_special_file_warning  = undef,
  Optional[String]                     $bzr_commit_options          = $::etckeeper::params::bzr_commit_options,
  Stdlib::Absolutepath                 $conf_dir                    = $::etckeeper::params::conf_dir,
  Optional[String]                     $darcs_commit_options        = $::etckeeper::params::darcs_commit_options,
  Optional[String]                     $git_commit_options          = $::etckeeper::params::git_commit_options,
  Optional[String]                     $hg_commit_options           = $::etckeeper::params::hg_commit_options,
  Etckeeper::PackageManager::HighLevel $highlevel_package_manager   = $::etckeeper::params::highlevel_package_manager,
  Etckeeper::PackageManager::LowLevel  $lowlevel_package_manager    = $::etckeeper::params::lowlevel_package_manager,
  String                               $package_name                = $::etckeeper::params::package_name,
  Optional[Array[String, 1]]           $push_remotes                = undef,
  Etckeeper::VCS                       $vcs                         = $::etckeeper::params::vcs,
  Hash[String, String]                 $vcs_packages                = $::etckeeper::params::vcs_packages,
) inherits ::etckeeper::params {

  contain ::etckeeper::install
  contain ::etckeeper::config

  Class['::etckeeper::install'] -> Class['::etckeeper::config']
}
