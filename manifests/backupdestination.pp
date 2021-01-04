# @summary create a backupdestination in specified file
# @param path
#   sets parameter of the same name in the backupdestination
# @param inplace
#   sets parameter of the same name in the backupdestination
# @param zfscreate
#   sets parameter of the same name in the backupdestination
# @param zfssnapshot
#   sets parameter of the same name in the backupdestination
# @param backup_type
#   sets the type parameter in the backupdestination
# @param percentused
#   sets parameter of the same name in the backupdestination
# @param minfree
#   sets parameter of the same name in the backupdestination
# @param maxinc
#   sets parameter of the same name in the backupdestination
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
#
# @param concat
#   instead of creating a file, use concat to add to file with concat::fragment
# @example Simple backupdestination
#   rdbduprunner::backupdestination { 'mylss':
#     path => '/mnt/nfs/lc-stor/bob/backups',
#   }
define rdbduprunner::backupdestination
(
  String $path,
  Optional[Boolean]    $inplace = undef,
  Optional[Boolean]    $zfscreate = undef,
  Optional[Boolean]    $zfssnapshot = undef,
  Enum['rsync','duplicity','rdiff-backup']    $backup_type = 'rsync',
  Optional[Integer]    $percentused = undef,
  Optional[Integer]    $minfree = undef,
  Optional[Integer]    $maxinc = undef,
  Enum['present','absent'] $ensure = 'present',
  Variant[String,Integer] $owner   = 'root',
  Variant[String,Integer] $group   = 0,
  String $mode                     = '0440',
  String $config_file              = "/etc/rdbduprunner/conf.d/backupdestination-${title}.conf",
  Boolean $concat                  = false,
)
{
  $integer_vars = ['PercentUsed','MinFree','MaxInc']
  $string_vars = ['Path']
  $boolean_vars = ['Inplace','ZfsCreate','ZfsSnapshot']
  if $concat {
    concat::fragment { "backupdestination/${title}/${config_file}":
      target  => $config_file,
      content => template('rdbduprunner/backupdestination.erb'),
      order   => "20-${title}",
    }
  }
  else {
    file { $config_file:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      content => template('rdbduprunner/backupdestination.erb'),
    }
  }
}
