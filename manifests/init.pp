# @summary install and configure rdbduprunner
#
# @param packages
#   install these perl packages to make rdbduprunner run
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
# @param config_dir
#    configuration directory (typically /etc/rdbduprunner)
#
# @param config_file
#    config file to manage
#
# @param zfsbinary
#    sets global rdbduprunner parameter of the same name
#
# @param defaultbackupdestination
#    sets global rdbduprunner parameter of the same name
#
# @param maxprocs
#    sets global rdbduprunner parameter of the same name
#
# @param maxinc
#    sets global rdbduprunner parameter of the same name
#
# @param duplicitybinary
#    path to duplicity
#
# @param rdiffbackupbinary
#    path to rdiff-backup
#
# @param rsyncbinary
#    path to rsync
#
# @param lockfile
#    do not use this, not sure what it does
#
# @param useagent
#    passes --use-agent to duplicity
#
# @param tempdir
#    tries to convince underlying backup software to use this directory for temp files
#
# @param maxwait
#    sets global rdbduprunner parameter of the same name
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
# @param log_level Enum['debug','info','notice','warning','error','critical','alert','emergency']
#   passed to rdbduprunner as is to determine verbosity of log output
# @param cmd [String]
#   how to invoke rdbduprunner, passed through inline_template to substitute the path to rdbduprunner, etc.
# @param executable
#   where to put rdbduprunner, typically /usr/bin/rdbduprunner
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
# @param rsync_tag_excludes
#   creates files in the "excludes" directory, named after the tag referenced, see examples
#
# @param rdbdup_tag_excludes
#   creates files in the "rdb-excludes" directory, named after the tag referenced, see examples
#
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
#      skips:
#        - /boot
#      excludes:
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
  Array[String] $packages,
  Variant[String,Integer] $owner,
  Variant[String,Integer] $group,
  String $mode,
  String $config_dir,
  String $config_file,
  # the following are global rdbduprunner config options
  Optional[String]     $zfsbinary = undef,
  Optional[String]     $defaultbackupdestination = undef,
  Optional[String]     $excludepath = undef,
  Optional[Integer]     $maxprocs = undef,
  Optional[Integer]     $maxinc = undef,
  Optional[String]     $duplicitybinary = undef,
  Optional[String]     $rdiffbackupbinary = undef,
  Optional[String]     $rsyncbinary = undef,
  Optional[String]     $lockfile = undef,
  Optional[Boolean]     $useagent = undef,
  Optional[String]     $tempdir = undef,
  Optional[Integer]     $maxwait = undef,
  Hash[String,Struct[{
    zfscreate                => Optional[Boolean],
    zfssnapshot              => Optional[Boolean],
    inplace                  => Optional[Boolean],
    backup_type              => Optional[Enum['rsync','duplicity','rdiff-backup']],
    path                     => String,
    percentused              => Optional[Integer],
    minfree                  => Optional[Integer],
    maxinc                   => Optional[Integer],
  }]] $backupdestinations,
  Hash[String,Struct[{
    config_file              => Optional[String],
    host                     => Optional[String],
    paths                    => Optional[Array[String]],
    skips                    => Optional[Array[String]],
    skipres                  => Optional[Array[String]],
    excludes                 => Optional[Array[String]],
    backupdestination        => Optional[String],
    inventory                => Optional[Boolean],
    inplace                  => Optional[Boolean],
    prerun                   => Optional[String],
    postrun                  => Optional[String],
    rtag                     => Optional[String],
    disabled                 => Optional[Boolean],
    maxinc                   => Optional[Integer],
    export                   => Optional[Boolean],
    tag                      => Optional[String],
  }]] $backupsets,
  Array[String] $default_skips,
  Array[String] $default_skipres,
  Enum['cron','cron.d','anacron','systemd','none'] $cron_method,
  Enum['monthly','weekly','daily','hourly','yearly'] $anacron_frequency,
  String $cron_resource_name,
  String $systemd_service_name,
  # there are a lot of ways to specify these to the cron type and I'm
  # not going to try to determine the type spec used
  $hour        = fqdn_rand(4),
  $minute      = fqdn_rand(60),
  $monthday    = undef,
  $month       = undef,
  $weekday     = undef,
  Enum['debug','info','notice','warning','error','critical','alert','emergency'] $log_level,
  String $cmd,
  String $executable,
  Hash[String,Array[String]] $rsync_tag_excludes = {},
  Hash[String,Array[String]] $rdbdup_tag_excludes = {},
  String $repo,
  Optional[String] $repo_revision = undef,
  Enum['present','absent'] $logrotate,
  Boolean $purge_excludes,
) {

  contain rdbduprunner::install
  contain rdbduprunner::configure
  contain rdbduprunner::service

  Class['::rdbduprunner::install']
  -> Class['::rdbduprunner::configure']
  ~> Class['::rdbduprunner::service']
}
