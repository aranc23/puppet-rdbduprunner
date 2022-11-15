# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::backupdestination' do
  let(:title) { 'namevar' }
  let(:params) do
    { 'path' => '/tmp/backup' }
  end
  let(:pre_condition) { 'include rdbduprunner' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupdestination-namevar.conf")
                            .with( 'ensure'  => 'absent') }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupdestination-namevar.yaml")
                            .with(
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "---\nbackupdestination:\n  namevar:\n    path: \"/tmp/backup\"\n    type: rsync\n",
                                 )
      }    
      it { is_expected.not_to contain_concat__fragment('backupdestination/namevar//etc/rdbduprunner/conf.d/backupdestination-namevar.conf') }
    end
    context "old params" do
      let(:params) do
        super().merge(
        {
          'config_file' => "/etc/rdbduprunner/conf.d/backupdestination-not-namevar.yaml",
          'inplace' => false,
          'checksum' => true,
          'wholefile' => false,
          'stats' => true,
          'zfscreate' => false,
          'zfssnapshot' => true,
          'backup_type' => 'rdiff-backup',
          'percentused' => 5,
          'minfree' => 22,
          'maxinc' => 7,
        })
      end
      it { is_expected.to compile }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupdestination-not-namevar.conf")
                            .with( 'ensure'  => 'absent' ) }
      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupdestination-not-namevar.yaml")
                            .with(
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "---
backupdestination:
  namevar:
    checksum: true
    inplace: false
    maxinc: 7
    minfree: 22
    path: \"/tmp/backup\"
    percentused: 5
    stats: true
    type: rdiff-backup
    wholefile: false
    zfscreate: false
    zfssnapshot: true
")
      }    
      
    end
    context "all params" do
      let(:params) do
        super().merge(
        {
          'allowfs' => ['ext','ext2'],
          'awsaccesskeyid' => 'tester',
          'awssecretaccesskey' => 'test',
          'busted' => true,
          'checksum' => true,
          'duplicitybinary' => '/usr/local/bin/duplicity',
          'inplace' => false,
          'maxage' => '4d',
          'maxinc' => 4,
          'path' => '/tmp/backup',
          'percentused' => 4,
          'postrun' => 'o',
          'prerun' => 'r',
          'rdiffbackupbinary' => '/usr/local/bin/rdiff-backup',
          'rsyncbinary' => '/local/rsync',
          'skip' => ['a'],
          'skipfstype' => 'zfs',
          'skipre' => ['4','3'],
          'sshcompress' => true,
          'stats' => false,
          'trickle' => 5,
          'tricklebinary' => '/bin/trickle',
          'useagent' => true,
          'verbosity' => 5,
          'volsize' => 1000,
          'wholefile' => false,
          'zfsbinary' => '/usr/sbin/zfs',
          'zfscreate' => true,
          'zfssnapshot' => false,
          'backup_type' => 'rdiff-backup',
        })
      end
      it { is_expected.to compile }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupdestination-namevar.yaml")
                            .with(
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "---
backupdestination:
  namevar:
    allowfs:
    - ext
    - ext2
    awsaccesskeyid: tester
    awssecretaccesskey: test
    busted: true
    checksum: true
    duplicitybinary: \"/usr/local/bin/duplicity\"
    inplace: false
    maxage: 4d
    maxinc: 4
    path: \"/tmp/backup\"
    percentused: 4
    postrun: o
    prerun: r
    rdiffbackupbinary: \"/usr/local/bin/rdiff-backup\"
    rsyncbinary: \"/local/rsync\"
    skip:
    - a
    skipfstype: zfs
    skipre:
    - '4'
    - '3'
    sshcompress: true
    stats: false
    trickle: 5
    tricklebinary: \"/bin/trickle\"
    type: rdiff-backup
    useagent: true
    verbosity: 5
    volsize: 1000
    wholefile: false
    zfsbinary: \"/usr/sbin/zfs\"
    zfscreate: true
    zfssnapshot: false
")
      }    
      
    end
  end
end
