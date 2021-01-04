# @summary creates one backupset definition in specified file, used by the main module and ::backup and ::autobackup helpers
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
# @param host
#   sets parameter of the same name in the backupset, although there is no default for the define, rdbduprunner uses localhost if it isn't set
# @param disabled
#   sets parameter of the same name in the backupset
# @param backupdestination
#   sets parameter of the same name in the backupset
# @param inventory
#   sets parameter of the same name in the backupset
# @param inplace
#   sets parameter of the same name in the backupset
# @param prerun
#   sets parameter of the same name in the backupset
# @param postrun
#   sets parameter of the same name in the backupset
# @param maxinc
#   sets parameter of the same name in the backupset
# @param paths
#   for each entry in this array, create a Path X statement in backupset
# @param excludes
#   for each entry in this array, create a Exclude X statement in backupset
# @param skips
#   for each entry in this array, create a Skip X statement in backupset
# @param skipres
#   for each entry in this array, create a SkipRE X statement in backupset
# @param ensure the usual present/absent magic
# @param rtag
#   override the tag in the backupset configuration, called rtag because tag is reserved
#
# @example add a backupset for a host to a config file in conf.d
#   rdbduprunner::backupset { 'badhost':
#     host => 'badhost',
#     inventory => false,
#     paths => ['data'],
#     excludes => ['not_backed_up'],
#   }
#
define rdbduprunner::backupset
(
  Enum['present','absent'] $ensure = 'present',
  Variant[String,Integer] $owner   = 'root',
  Variant[String,Integer] $group   = 0,
  String $mode                     = '0440',
  String $config_file              = "/etc/rdbduprunner/conf.d/backupset-${title}.conf",
  Boolean $concat                  = false,
  # the following elements are used in the actual template
  Optional[String] $host = undef,
  Optional[Array[String]] $paths = undef,
  Optional[Array[String]] $skips = undef,
  Optional[Array[String]] $skipres = undef,
  Optional[Array[String]] $excludes = undef,
  Optional[String] $backupdestination = undef,
  Optional[Boolean] $inventory = undef,
  Optional[Boolean] $inplace = undef,
  Optional[String] $prerun = undef,
  Optional[String] $postrun = undef,
  Optional[String] $rtag = undef,
  Optional[Boolean] $disabled = undef,
  Optional[Integer] $maxinc = undef,
)
{
  $integer_vars = ['MaxInc']
  $array_vars = ['Path','Exclude','SkipRE','Skip']

  if $concat {
    concat::fragment { "backupset|${title}|${config_file}":
      target  => $config_file,
      content => template('rdbduprunner/backupset.erb'),
      order   => "30-${title}",
    }
  }
  else {
    file { $config_file:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      content => template('rdbduprunner/backupset.erb'),
    }
  }
}
