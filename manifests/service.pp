# @summary used by rdbduprunner to configure the service
class rdbduprunner::service
(
)
{
  $executable = $rdbduprunner::executable
  $config_file = $rdbduprunner::config_file
  $hour     = $rdbduprunner::hour
  $minute   = $rdbduprunner::minute
  $monthday = $rdbduprunner::monthday
  $month    = $rdbduprunner::month
  $weekday  = $rdbduprunner::weekday
  $user     = $rdbduprunner::owner

  $cmd_resolved = inline_template($rdbduprunner::cmd)
  file { "/etc/cron.d/${rdbduprunner::cron_resource_name}":
    ensure  => $rdbduprunner::cron_method ? { 'cron.d' => present, default => absent },
    owner   => $rdbduprunner::owner,
    group   => $rdbduprunner::group,
    mode    => '0644',
    content => template('rdbduprunner/cron.d.erb'),
  }
  Enum['monthly','weekly','daily','hourly','yearly'].each |String $freq| {
    $ensure_value = $rdbduprunner::cron_method ? {
      'anacron' => $freq ? {
        $rdbduprunner::anacron_frequency => present,
        default => absent,
      },
      default => absent,
    }
    file { "/etc/cron.${freq}/${rdbduprunner::cron_resource_name}":
      ensure  => $ensure_value,
      owner   => $rdbduprunner::owner,
      group   => $rdbduprunner::group,
      mode    => '0550',
      content => "#!/bin/sh\n${cmd_resolved}\n",
    }
  }
  cron { $rdbduprunner::cron_resource_name:
    ensure   => $rdbduprunner::cron_method ? { 'cron' => present, default => absent },
    user     => $rdbduprunner::owner,
    command  => $cmd_resolved,
    hour     => $rdbduprunner::hour,
    minute   => $rdbduprunner::minute,
    monthday => $rdbduprunner::monthday,
    month    => $rdbduprunner::month,
    weekday  => $rdbduprunner::weekday,
  }
  # questionable
  file { '/etc/logrotate.d/rdbduprunner':
    ensure => $rdbduprunner::logrotate,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0644',
    source => 'puppet:///modules/rdbduprunner/logrotate.d/rdbduprunner',
  }
}
