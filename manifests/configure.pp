# @summary used by rdbduprunner to configure the software
class rdbduprunner::configure
(
)
{
  $_global = {
    allowfs => $rdbduprunner::allowfs,
    awsaccesskeyid => $rdbduprunner::awsaccesskeyid,
    awssecretaccesskey => $rdbduprunner::awssecretaccesskey,
    checksum => $rdbduprunner::checksum,
    defaultbackupdestination => $rdbduprunner::defaultbackupdestination,
    duplicitybinary => $rdbduprunner::duplicitybinary,
    encryptkey => $rdbduprunner::encryptkey,
    excludepath => $rdbduprunner::excludepath,
    facility => $rdbduprunner::facility,
    gpgpassphrase => $rdbduprunner::gpgpassphrase,
    inplace => $rdbduprunner::inplace,
    level => $rdbduprunner::level,
    localhost => $rdbduprunner::localhost,
    maxage => $rdbduprunner::maxage,
    maxinc => $rdbduprunner::maxinc,
    maxprocs => $rdbduprunner::maxprocs,
    maxwait => $rdbduprunner::maxwait,
    postrun => $rdbduprunner::postrun,
    prerun => $rdbduprunner::prerun,
    rdiffbackupbinary => $rdbduprunner::rdiffbackupbinary,
    rsyncbinary => $rdbduprunner::rsyncbinary,
    signkey => $rdbduprunner::signkey,
    skip => $rdbduprunner::skip,
    skipfstype => $rdbduprunner::skipfstype,
    skipre => $rdbduprunner::skipre,
    sshcompress => $rdbduprunner::sshcompress,
    stats => $rdbduprunner::stats,
    tempdir => $rdbduprunner::tempdir,
    trickle => $rdbduprunner::trickle,
    tricklebinary => $rdbduprunner::tricklebinary,
    useagent => $rdbduprunner::useagent,
    verbosity => $rdbduprunner::verbosity,
    volsize => $rdbduprunner::volsize,
    wholefile => $rdbduprunner::wholefile,
    zfsbinary => $rdbduprunner::zfsbinary,
    zfscreate => $rdbduprunner::zfscreate,
    zfssnapshot => $rdbduprunner::zfssnapshot,
    backupdestination => $rdbduprunner::backupdestinations,
    backupset => $rdbduprunner::backupsets,
  }.filter |$k,$v| { $v =~ NotUndef }

  file { '/etc/rdbduprunner.rc':
    ensure => absent,
  }
  file { $rdbduprunner::config_file:
    owner   => $rdbduprunner::owner,
    group   => $rdbduprunner::group,
    mode    => '0440',
    content => to_yaml($_global),
  }

  file { "${rdbduprunner::config_dir}/excludes":
    ensure => directory,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0775',
    purge  => $rdbduprunner::purge_excludes,
  }
  $rdbduprunner::rsync_tag_excludes.each |String $tag, Array $e| {
    file { "${rdbduprunner::config_dir}/excludes/${tag}":
      owner   => $rdbduprunner::owner,
      group   => $rdbduprunner::group,
      mode    => '0664',
      content => inline_template("<% @e.each do |ln| -%><%= ln %>\n<% end -%>"),
    }
  }
  file { "${rdbduprunner::config_dir}/rdb-excludes":
    ensure => directory,
    owner  => $rdbduprunner::owner,
    group  => $rdbduprunner::group,
    mode   => '0775',
    purge  => $rdbduprunner::purge_excludes,
  }
  $rdbduprunner::rdbdup_tag_excludes.each |String $tag, Array $e| {
    file { "${rdbduprunner::config_dir}/rdb-excludes/${tag}":
      owner   => $rdbduprunner::owner,
      group   => $rdbduprunner::group,
      mode    => '0644',
      content => inline_template("<% @e.each do |ln| -%><%= ln %>\n<% end -%>"),
    }
  }
}
