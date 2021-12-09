# Installs etckeeper.
#
# @example Declaring the class
#   include etckeeper
#
# @example Choosing a specific VCS instead of the default
#   class { 'etckeeper':
#     vcs => 'bzr',
#   }
#
# @example Forcing the user name & email for commits
#   class { 'etckeeper':
#     vcs            => 'git',
#     vcs_user_name  => 'Alice',
#     vcs_user_email => 'alice@example.com',
#   }
#
# @param assume_epel Assume EPEL repository installed (Red Hat variants only)
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
# @param manage_vcs_package
# @param package_name The name of the package.
# @param push_remotes
# @param vcs
# @param vcs_packages Hash of VCS to the package that provides it.
# @param vcs_user_email
# @param vcs_user_name
#
# @see puppet_defined_types::etckeeper::ignore etckeeper::ignore
#
# @since 1.0.0
class etckeeper (
  Optional[Boolean]                    $assume_epel,
  Optional[Boolean]                    $avoid_commit_before_install,
  Optional[Boolean]                    $avoid_daily_autocommits,
  Optional[Boolean]                    $avoid_special_file_warning,
  Optional[String]                     $bzr_commit_options,
  Stdlib::Absolutepath                 $conf_dir,
  Optional[String]                     $darcs_commit_options,
  Optional[String]                     $git_commit_options,
  Optional[String]                     $hg_commit_options,
  Etckeeper::PackageManager::HighLevel $highlevel_package_manager,
  Etckeeper::PackageManager::LowLevel  $lowlevel_package_manager,
  Boolean                              $manage_vcs_package,
  String                               $package_name,
  Optional[Array[String, 1]]           $push_remotes,
  Etckeeper::VCS                       $vcs,
  Hash[Etckeeper::VCS, String]         $vcs_packages,
  Optional[String[1]]                  $vcs_user_email,
  Optional[String[1]]                  $vcs_user_name,
) {

  contain etckeeper::install
  contain etckeeper::config

  Class['etckeeper::install'] -> Class['etckeeper::config']
}
