# @summary used by rdbduprunner to install the software
class rdbduprunner::install
(
)
{
  ensure_packages($rdbduprunner::packages)
  file { $rdbduprunner::config_dir:
    ensure => directory,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0775',
  }
  -> vcsrepo { "${rdbduprunner::config_dir}/repo":
    ensure   => present,
    provider => git,
    source   => $rdbduprunner::repo,
    revision => $rdbduprunner::repo_revision,
  }
  -> file { $rdbduprunner::executable:
    owner  => 'root',
    group  => 0,
    mode   => '0555',
    source => "${rdbduprunner::config_dir}/repo/rdbduprunner",
  }
  file { "${rdbduprunner::config_dir}/conf.d":
    ensure => directory,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0755',
  }
  file { ['/var/run/rdbduprunner','/var/log/rdbduprunner']:
    ensure => directory,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0770',
  }
}
