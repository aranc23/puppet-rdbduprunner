# @summary create a backupdestination in specified file
#
# @param allowfs
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param awsaccesskeyid
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param awssecretaccesskey
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param busted
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param checksum
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param duplicitybinary
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param encryptkey
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param gpgpassphrase
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param inplace
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param maxage
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param maxinc
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param minfree
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param path
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param percentused
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param postrun
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param prerun
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param rdiffbackupbinary
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param rsyncbinary
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param signkey
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param skip
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param skipfstype
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param skipre
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param sshcompress
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param stats
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param trickle
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param tricklebinary
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param backup_type
#   sets parameter type in backupdestination
#   see rdbduprunner docs for details
# @param useagent
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param verbosity
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param volsize
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param wholefile
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param zfsbinary
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param zfscreate
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
# @param zfssnapshot
#   sets parameter of the same name in backupdestination
#   see rdbduprunner docs for details
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
#    config file in which to create the backupdestination definition
#    must end in .yaml or .yml
#
#
# @example Simple backupdestination
#   rdbduprunner::backupdestination { 'mylss':
#     path => '/mnt/nfs/lc-stor/bob/backups',
#   }
define rdbduprunner::backupdestination
(
  Stdlib::UnixPath $path,
  Optional[Variant[String,Array[String]]] $allowfs = undef,
  Optional[String] $awsaccesskeyid = undef,
  Optional[String] $awssecretaccesskey = undef,
  Optional[Boolean] $busted = undef,
  Optional[Boolean] $checksum = undef,
  Optional[Stdlib::UnixPath] $duplicitybinary = undef,
  Optional[String] $encryptkey = undef,
  Optional[String] $gpgpassphrase = undef,
  Optional[Boolean] $inplace = undef,
  Optional[String] $maxage = undef,
  Optional[Integer] $maxinc = undef,
  Optional[Integer] $minfree = undef,
  Optional[Integer] $percentused = undef,
  Optional[String] $postrun = undef,
  Optional[String] $prerun = undef,
  Optional[Stdlib::UnixPath] $rdiffbackupbinary = undef,
  Optional[Stdlib::UnixPath] $rsyncbinary = undef,
  Optional[String] $signkey = undef,
  Optional[Variant[String,Array[String]]] $skip = undef,
  Optional[Variant[String,Array[String]]] $skipfstype = undef,
  Optional[Variant[String,Array[String]]] $skipre = undef,
  Optional[Boolean] $sparse = undef,
  Optional[Boolean] $sshcompress = undef,
  Optional[Boolean] $stats = undef,
  Optional[Integer] $trickle = undef,
  Optional[Stdlib::UnixPath] $tricklebinary = undef,
  Enum['rsync','duplicity','rdiff-backup'] $backup_type = 'rsync',
  Optional[Boolean] $useagent = undef,
  Optional[Integer] $verbosity = undef,
  Optional[Integer] $volsize = undef,
  Optional[Boolean] $wholefile = undef,
  Optional[Stdlib::UnixPath] $zfsbinary = undef,
  Optional[Boolean] $zfscreate = undef,
  Optional[Boolean] $zfssnapshot = undef,

  Variant[String,Integer] $owner = $rdbduprunner::owner,
  Variant[String,Integer] $group = $rdbduprunner::group,
  Stdlib::Filemode $mode = $rdbduprunner::mode,
  Stdlib::UnixPath $config_file = "${rdbduprunner::config_dir}/conf.d/backupdestination-${title}.yaml",
)
{
  include rdbduprunner
  validate_re($config_file,'\.(yaml|yml)$', 'config file must end in yml or yaml')

  $_backupdestination = { backupdestination => { $title => {
    allowfs => $allowfs,
    awsaccesskeyid => $awsaccesskeyid,
    awssecretaccesskey => $awssecretaccesskey,
    busted => $busted,
    checksum => $checksum,
    duplicitybinary => $duplicitybinary,
    encryptkey => $encryptkey,
    gpgpassphrase => $gpgpassphrase,
    inplace => $inplace,
    maxage => $maxage,
    maxinc => $maxinc,
    minfree => $minfree,
    path => $path,
    percentused => $percentused,
    postrun => $postrun,
    prerun => $prerun,
    rdiffbackupbinary => $rdiffbackupbinary,
    rsyncbinary => $rsyncbinary,
    signkey => $signkey,
    skip => $skip,
    skipfstype => $skipfstype,
    skipre => $skipre,
    sparse => $sparse,
    sshcompress => $sshcompress,
    stats => $stats,
    trickle => $trickle,
    tricklebinary => $tricklebinary,
    'type' => $backup_type,
    useagent => $useagent,
    verbosity => $verbosity,
    volsize => $volsize,
    wholefile => $wholefile,
    zfsbinary => $zfsbinary,
    zfscreate => $zfscreate,
    zfssnapshot => $zfssnapshot,
  }.filter |$k,$v| { $v =~ NotUndef } } }

  file { regsubst($config_file,'\.(yaml|yml)$','.conf'):
    ensure => absent,
  }
  file { $config_file:
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => to_yaml($_backupdestination),
  }
}
