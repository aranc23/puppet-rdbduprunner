# @summary creates one backupset and one backupdestination in conf.d
#
# @param destination
#   where to write the backups, used in the backupset
# @param owner
#   user uid to create configuration file as
# @param group
#   group or gid for the configuration file
# @param mode
#   octal mode string for config file
# @param host
#   which host to back up, leave blank for localhost
# @param rtag
#   override the tag in the backupset configuration, called rtag because tag is reserved
# @param disabled
#   sets parameter of the same name in the backupset
# @param inventory
#   sets parameter of the same name in the backupset
# @param inplace
#   sets parameter of the same name in the backupset
# @param sparse
#   sets parameter of the same name in the backupset
# @param prerun
#   sets parameter of the same name in the backupset
# @param postrun
#   sets parameter of the same name in the backupset
# @param paths
#   for each entry in this array, create a Path X statement in backupset
# @param excludes
#   for each entry in this array, create a Exclude X statement in backupset
# @param skips
#   for each entry in this array, create a Skip X statement in backupset
# @param skipres
#   for each entry in this array, create a SkipRE X statement in backupset
# @param backup_type
#   set the backup "type" of the destination
#
# @example Backing up to lss share
#   rdbduprunner::autobackup { 'lss':
#     destination => '/mnt/nfs/lc-something/userbob/backups',
#     inventory => true,
#     skips => ['/boot'],
#     excludes => ['not_backed_up'],
#   }
#
define rdbduprunner::autobackup
(
  # path to write backups to
  String $destination,
  String $directory                = "${rdbduprunner::config_dir}/conf.d",
  Optional[String] $host = undef,
  Variant[String,Undef] $rtag      = undef,
  Optional[Boolean] $disabled   = undef,
  Variant[String,Undef] $backupdestination = $title,
  Variant[Boolean,Undef] $inventory = true,
  Variant[String,Undef] $prerun    = undef,
  Variant[String,Undef] $postrun   = undef,
  Array[String] $paths             = [],
  Array[String] $skips             = [ '/var/lib/mysql', '/var/lib/pgsql' ],
  Array[String] $skipres           = [ '^\/run\/media', '^\/var\/lib\/docker\/devicemapper' ],
  Array[String] $excludes          = [],
  Optional[Boolean] $inplace = undef,
  Optional[Boolean] $sparse = undef,
  Optional[Boolean] $wholefile = false,
  Enum['rsync','duplicity','rdiff-backup'] $backup_type = 'rsync',
)
{
  include ::rdbduprunner

  # old configuration file:
  file { "${directory}/${title}.conf":
    ensure => absent,
  }
  rdbduprunner::backupdestination { $backupdestination:
    backup_type => $backup_type,
    path        => $destination,
    inplace     => $inplace,
    wholefile   => $wholefile,
  }
  $backupset = {
    host              => $host,
    rtag              => $rtag,
    disabled          => $disabled,
    backupdestination => $backupdestination,
    inventory         => $inventory,
    inplace           => $inplace,
    sparse            => $sparse,
    prerun            => $prerun,
    postrun           => $postrun,
    path              => $paths,
    skip              => unique(sort(flatten(concat($skips, [ '/var/lib/mysql', '/var/lib/pgsql' ])))),
    skipre            => unique(sort(flatten(concat($skipres, [ '^\/run\/media', '^\/var\/lib\/docker\/devicemapper' ])))),
    exclude           => $excludes,
  }
  rdbduprunner::backupset { 'autobackup':
    *           => $backupset,
  }
  # rely on the rdbduprunner module to run rdbduprunner
  file { "/etc/cron.daily/rdbduprunner_autobackup_${title}.sh":
    ensure => absent,
  }
}
