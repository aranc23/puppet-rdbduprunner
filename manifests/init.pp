# @summary install and configure rdbduprunner
#
# install rdbduprunner from a file source, configure the service!
#
#
#
# @param package
#   install this package, presumably it's rdbduprunner
#
# @param package_ensure
#   passed to the package ensure resource, for specifying specific version or latest
#
# param extra_packages
#   install these extras, presumably to make rdbduprunner work
# @param owner
#    set most/some files to this user or uid
#
# @param group
#    set most/some files to this group or gid
#
# @param mode
#    set most/some files to this octal mode string
#
# @param config_dir
#    configuration directory (typically /etc/rdbduprunner)
#
# @param manage_conf_d
#    manage the $config_dir/conf.d directory, by recursively purging
#
# @param config_file
#    config file to manage, don't change this
#    must end in .yaml or .yml
#
# @param default_skips
#    adds these to the skips array in backup sets, kind of useless, may be removed
#
# @param default_skipres
#    adds these to the skipres array in backup sets, kind of useless, may be removed
#
# @param cron_method
#    how to configure the invocation of rdbduprunner periodically
#    systemd is not implemented and none configures none
#
# @param anacron_frequency
#    if using anacron as above, which directory do we put the run script in
#
# @param cron_resource_name
#   what do we call the file in anacron or cron.d, the special name in cron, etc.
#
# @param systemd_service_name
#   what to name the systemd service (not implemented)
#
# @param hour
#   used in the cron.d and traditional cron entries
#
# @param minute
#   used in the cron.d and traditional cron entries
#
# @param monthday
#   used in the cron.d and traditional cron entries
#
# @param month
#   used in the cron.d and traditional cron entries
#
# @param weekday
#   used in the cron.d and traditional cron entries
#
# @param cmd [String]
#   how to invoke rdbduprunner, passed through inline_template to substitute the path to rdbduprunner, etc.
# @param executable
#   where to find rdbduprunner
# @param rsync_tag_excludes Hash[String,Array[String]]
#   replaces static files in /etc/rdbduprunner/excludes, keyed by "tag" and then a list of excludes
#   => { 'a-lnx005.divms.uiowa.edu-home-accx' => [ 'hidden_stuff', 'DVDs' ] }
# @param rdbdup_tag_excludes Hash[String,Array[String]]
#   replaces static files in /etc/rdbduprunner/rdb-excludes, keyed by "tag" and then a list of excludes
#   => { 'a-lnx005.divms.uiowa.edu-home-accx' => [ '/home/accx/hidden_stuff', '/home/accx/DVDs' ] }
#
# @param backupsets
#   creates backupset definitions, refer to rdbduprunner documentation for specifics
#
# @param backupdestinations
#   creates backupdestination definitions, refer to rdbduprunner documentation for specifics
#
# @param logrotate
#   add a logrotate script for rdbduprunner logs
# @param purge_excludes
#   purge non-managed files from the exclude directories (rdb-excludes and excludes)
# @param allowfs
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param awsaccesskeyid
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param awssecretaccesskey
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param backupdestination
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param backupset
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param checksum
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param defaultbackupdestination
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param duplicitybinary
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param encryptkey
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param excludepath
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param facility
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param gpgpassphrase
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param inplace
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param level
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param localhost
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param maxage
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param maxinc
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param maxprocs
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param maxwait
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param postrun
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param prerun
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param rdiffbackupbinary
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param rsyncbinary
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param signkey
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param skip
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param skipfstype
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param skipre
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param sshcompress
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param stats
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param tempdir
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param trickle
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param tricklebinary
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param useagent
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param verbosity
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param volsize
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param wholefile
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param zfsbinary
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param zfscreate
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @param zfssnapshot
#   sets parameter of the same name in global
#   see rdbduprunner docs for details
# @example Basic usage
#  include rdbduprunner
#
# @example Customize path to rdiff-backup
#  class { 'rdbduprunner':
#    rdiffbackupbinary => '/opt/bin/rdiff-backup',
#  }
#
# @example Create a backupdestination and backupset
#  class {'rdbduprunner':
#    defaultbackupdestination => 'lss',
#    backupdestinations => { 'lss' => { path => '/mnt/lss/backups'} },
#    backupsets         => { 'lss_backups' => { inventory => true, skips => ['/boot'] } },
#  }
#
# @example Configuring in hiera
#  rdbduprunner::defaultbackupdestination: 'lss'
#  rdbduprunner::backupdestination:
#    lss:
#      path: '/mnt/lss/backups'
#  rdbduprunner::backupsets:
#    lss_backups:
#      inventory: true
#      skip:
#        - /boot
#      exclude:
#        - not_backed_up
#
# @example Configuring a per-host-filesystem exclude file
#   rdbduprunner::rsync_tag_excludes:
#     - 'a-lnx005-home-accx':
#       - '.cache'
#       - 'Downloads'
#
class rdbduprunner
(
  String $package = 'rdbduprunner',
  String $package_ensure = 'present',
  Array[String] $extra_packages = [],
  Variant[String,Integer] $owner = 'root',
  Variant[String,Integer] $group = 0,
  String $mode = '0440',
  String $config_dir = '/etc/rdbduprunner',
  Boolean $manage_conf_d = false,
  String $config_file = '/etc/rdbduprunner/rdbduprunner.yaml',

  # the following are global rdbduprunner config options
  Optional[Variant[String,Array[String]]] $allowfs = undef,
  Optional[String] $awsaccesskeyid = undef,
  Optional[String] $awssecretaccesskey = undef,
  Optional[Boolean] $checksum = undef,
  Optional[String] $defaultbackupdestination = undef,
  Optional[Stdlib::UnixPath] $duplicitybinary = undef,
  Optional[String] $encryptkey = undef,
  Optional[String] $excludepath = undef,
  Optional[String] $facility = undef,
  Optional[String] $gpgpassphrase = undef,
  Optional[Boolean] $inplace = undef,
  Optional[String] $level = undef,
  Optional[String] $localhost = undef,
  Optional[String] $maxage = undef,
  Optional[Integer] $maxinc = undef,
  Optional[Integer] $maxprocs = undef,
  Optional[Integer] $maxwait = undef,
  Optional[String] $postrun = undef,
  Optional[String] $prerun = undef,
  Optional[Stdlib::UnixPath] $rdiffbackupbinary = undef,
  Optional[Stdlib::UnixPath] $rsyncbinary = undef,
  Optional[String] $signkey = undef,
  Optional[Variant[String,Array[String]]] $skip = undef,
  Optional[Variant[String,Array[String]]] $skipfstype = undef,
  Optional[Variant[String,Array[String]]] $skipre = undef,
  Optional[Boolean] $sshcompress = undef,
  Optional[Boolean] $stats = undef,
  Optional[String] $tempdir = undef,
  Optional[Integer] $trickle = undef,
  Optional[Stdlib::UnixPath] $tricklebinary = undef,
  Optional[Boolean] $useagent = undef,
  Optional[Integer] $verbosity = undef,
  Optional[Integer] $volsize = undef,
  Optional[Boolean] $wholefile = undef,
  Optional[Stdlib::UnixPath] $zfsbinary = undef,
  Optional[Boolean] $zfscreate = undef,
  Optional[Boolean] $zfssnapshot = undef,
  Hash[String,Struct[{
    allowfs => Optional[Variant[String,Array[String]]],
    awsaccesskeyid => Optional[String],
    awssecretaccesskey => Optional[String],
    busted => Optional[Boolean],
    checksum => Optional[Boolean],
    duplicitybinary => Optional[Stdlib::UnixPath],
    encryptkey => Optional[String],
    gpgpassphrase => Optional[String],
    inplace => Optional[Boolean],
    maxage => Optional[String],
    maxinc => Optional[Integer],
    minfree => Optional[Integer],
    path => String,
    percentused => Optional[Integer],
    postrun => Optional[String],
    prerun => Optional[String],
    rdiffbackupbinary => Optional[Stdlib::UnixPath],
    rsyncbinary => Optional[Stdlib::UnixPath],
    signkey => Optional[String],
    skip => Optional[Variant[String,Array[String]]],
    skipfstype => Optional[Variant[String,Array[String]]],
    skipre => Optional[Variant[String,Array[String]]],
    sshcompress => Optional[Boolean],
    stats => Optional[Boolean],
    trickle => Optional[Integer],
    tricklebinary => Optional[Stdlib::UnixPath],
    'type' => Optional[Enum['rsync','duplicity','rdiff-backup']],
    useagent => Optional[Boolean],
    verbosity => Optional[Integer],
    volsize => Optional[Integer],
    wholefile => Optional[Boolean],
    zfsbinary => Optional[Stdlib::UnixPath],
    zfscreate => Optional[Boolean],
    zfssnapshot => Optional[Boolean],
  }]] $backupdestinations = {},
  Hash[String,Struct[{
    allowfs => Optional[Variant[String,Array[String]]],
    backupdestination => Optional[String],
    checksum => Optional[Boolean],
    disabled => Optional[Boolean],
    duplicitybinary => Optional[Stdlib::UnixPath],
    exclude => Optional[Variant[String,Array[String]]],
    excludes => Optional[Variant[String,Array[String]]],
    host => Optional[Stdlib::Host],
    inplace => Optional[Boolean],
    inventory => Optional[Boolean],
    maxage => Optional[String],
    maxinc => Optional[Integer],
    path => Optional[Variant[String,Array[String]]],
    paths => Optional[Variant[String,Array[String]]],
    postrun => Optional[String],
    prerun => Optional[String],
    rdiffbackupbinary => Optional[Stdlib::UnixPath],
    rsyncbinary => Optional[Stdlib::UnixPath],
    skip => Optional[Variant[String,Array[String]]],
    skips => Optional[Variant[String,Array[String]]],
    skipfstype => Optional[Variant[String,Array[String]]],
    skipre => Optional[Variant[String,Array[String]]],
    skipres => Optional[Variant[String,Array[String]]],
    sshcompress => Optional[Boolean],
    stats => Optional[Boolean],
    'tag' => Optional[String],
    trickle => Optional[Integer],
    tricklebinary => Optional[Stdlib::UnixPath],
    useagent => Optional[Boolean],
    verbosity => Optional[Integer],
    volsize => Optional[Integer],
    wholefile => Optional[Boolean],
    zfsbinary => Optional[Stdlib::UnixPath],
  }]] $backupsets = {},

  Array[String] $default_skips = [],
  Array[String] $default_skipres = [],
  Enum['cron','cron.d','anacron','systemd','none'] $cron_method = 'anacron',
  Enum['monthly','weekly','daily','hourly','yearly'] $anacron_frequency = 'daily',
  String $cron_resource_name = 'rdbduprunner',
  String $systemd_service_name = 'rdbduprunner',
  # there are a lot of ways to specify these to the cron type and I'm
  # not going to try to determine the type spec used
  $hour        = fqdn_rand(4),
  $minute      = fqdn_rand(60),
  $monthday    = undef,
  $month       = undef,
  $weekday     = undef,
  String $cmd = 'test -x /usr/bin/keychain && eval $( /usr/bin/keychain --eval --quiet ) ; <%= @executable %> --notest >/dev/null 2>&1',
  String $executable = '/usr/bin/rdbduprunner',
  Hash[String,Array[String]] $rsync_tag_excludes = {},
  Hash[String,Array[String]] $rdbdup_tag_excludes = {},
  Enum['present','absent'] $logrotate = 'present',
  Boolean $purge_excludes = false,
) {

  contain rdbduprunner::install
  contain rdbduprunner::configure
  contain rdbduprunner::service

  validate_re($config_file,'\.(yaml|yml)$', 'config file must end in yml or yaml')

  Class['::rdbduprunner::install']
  -> Class['::rdbduprunner::configure']
  ~> Class['::rdbduprunner::service']
}
