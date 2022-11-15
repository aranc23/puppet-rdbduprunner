# @summary creates one backupset definition in specified file, used by the main module and ::autobackup helpers
#
# @param owner
#    set most/some files to this user or uid
#
# @param group
#    set most/some files to this group or gid
#
# @param mode
#    set most/some files to this octal mode string
#
# @param config_file
#    config file in which to create the backupset definition
#    must end in .yml or .yaml
# @param allowfs
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param backupdestination
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param checksum
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param disabled
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param duplicitybinary
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param exclude
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param host
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param inplace
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param inventory
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param maxage
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param maxinc
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param path
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param postrun
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param prerun
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param rdiffbackupbinary
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param rsyncbinary
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param skip
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param skipfstype
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param skipre
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param sshcompress
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param stats
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param rtag
#   sets tag parameter in backupset
#   see rdbduprunner docs for details
# @param trickle
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param tricklebinary
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param useagent
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param verbosity
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param volsize
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param wholefile
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
# @param zfsbinary
#   sets parameter of the same name in backupset
#   see rdbduprunner docs for details
#
# @param file_ensure
#   when set to absent, remove the config file instead of creating it
# 
# @example add a backupset for a host to a config file in conf.d
#   rdbduprunner::backupset { 'badhost':
#     host => 'badhost',
#     inventory => false,
#     path => ['data'],
#     exclude => ['not_backed_up'],
#   }
#
define rdbduprunner::backupset
(
  Variant[String,Integer] $owner = $rdbduprunner::owner,
  Variant[String,Integer] $group = $rdbduprunner::group,
  Stdlib::Filemode $mode = $rdbduprunner::mode,
  Stdlib::UnixPath $config_file = "${rdbduprunner::config_dir}/conf.d/backupset-${title}.yaml",
  # the following elements generated by puppet-parms in the
  # rdbduprunner module:
  Optional[Variant[String,Array[String]]] $allowfs = undef,
  Optional[String] $backupdestination = undef,
  Optional[Boolean] $checksum = undef,
  Optional[Boolean] $disabled = undef,
  Optional[Stdlib::UnixPath] $duplicitybinary = undef,
  Optional[Variant[String,Array[String]]] $exclude = undef,
  Optional[Stdlib::Host] $host = undef,
  Optional[Boolean] $inplace = undef,
  Optional[Boolean] $inventory = undef,
  Optional[String] $maxage = undef,
  Optional[Integer] $maxinc = undef,
  Optional[Variant[String,Array[String]]] $path = undef,
  Optional[String] $postrun = undef,
  Optional[String] $prerun = undef,
  Optional[Stdlib::UnixPath] $rdiffbackupbinary = undef,
  Optional[Stdlib::UnixPath] $rsyncbinary = undef,
  Optional[Variant[String,Array[String]]] $skip = undef,
  Optional[Variant[String,Array[String]]] $skipfstype = undef,
  Optional[Variant[String,Array[String]]] $skipre = undef,
  Optional[Boolean] $sshcompress = undef,
  Optional[Boolean] $stats = undef,
  Optional[String] $rtag = undef,
  Optional[Integer] $trickle = undef,
  Optional[Stdlib::UnixPath] $tricklebinary = undef,
  Optional[Boolean] $useagent = undef,
  Optional[Integer] $verbosity = undef,
  Optional[Integer] $volsize = undef,
  Optional[Boolean] $wholefile = undef,
  Optional[Stdlib::UnixPath] $zfsbinary = undef,

  # pluralized strings:
  #Optional[Array[String]] $allowfs = undef,
  Optional[Array[String]] $excludes = [],
  Optional[Array[String]] $paths = [],
  Optional[Array[String]] $skips = [],
  #Optional[Variant[String,Array[String]]] $skipfstype = undef,
  Optional[Array[String]] $skipres = [],

  Enum['present','absent'] $file_ensure = 'present',
)
{
  include rdbduprunner
  validate_re($config_file,'\.(yaml|yml)$', 'config file must end in yml or yaml')
  if(length($excludes) > 0) {
    notice("backupset excludes option is deprecated in favor of exclude")
    if($exclude) {
      # don't sort or otherwise mangle this one as order may matter?
      $_exclude = flatten(concat([$exclude],$excludes))
    }
    else {
      $_exclude = $excludes
    }
  }
  else {
    $_exclude = $exclude
  }
  if(length($paths) > 0) {
    notice("backupset paths option is deprecated in favor of path")
    if($path) {
      $_path = unique(sort(flatten(concat([$path],$paths))))
    }
    else {
      $_path = $paths
    }
  }
  else {
    $_path = $path
  }
  if(length($skips) > 0) {
    notice("backupset skips option is deprecated in favor of skip")
    if($skip) {
      $_skip = unique(sort(flatten(concat([$skip],$skips))))
    }
    else {
      $_skip = $skips
    }
  }
  else {
    $_skip = $skip
  }
  if(length($skipres) > 0) {
    notice("backupset skipres option is deprecated in favor of skipre")
    if($skipre) {
      $_skipre = unique(sort(flatten(concat([$skipre],$skipres))))
    }
    else {
      $_skipre = $skipres
    }
  }
  else {
    $_skipre = $skipre
  }
  $_backupset = {
    allowfs => $allowfs,
    backupdestination => $backupdestination,
    checksum => $checksum,
    disabled => $disabled,
    duplicitybinary => $duplicitybinary,
    exclude => $_exclude,
    host => $host,
    inplace => $inplace,
    inventory => $inventory,
    maxage => $maxage,
    maxinc => $maxinc,
    path => $_path,
    postrun => $postrun,
    prerun => $prerun,
    rdiffbackupbinary => $rdiffbackupbinary,
    rsyncbinary => $rsyncbinary,
    skip => $_skip,
    skipfstype => $skipfstype,
    skipre => $_skipre,
    sshcompress => $sshcompress,
    stats => $stats,
    tag => $rtag,
    trickle => $trickle,
    tricklebinary => $tricklebinary,
    useagent => $useagent,
    verbosity => $verbosity,
    volsize => $volsize,
    wholefile => $wholefile,
    zfsbinary => $zfsbinary,
  }.filter |$k,$v| { $v =~ NotUndef }

  file { regsubst($config_file,'\.(yaml|yml)$','.conf'):
    ensure => absent,
  }
  file { $config_file:
    ensure  => $file_ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => to_yaml($_backupset),
  }
}
