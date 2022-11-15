# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::backupset' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end
  let(:pre_condition) { 'include rdbduprunner' }
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-namevar.conf")
                            .with('ensure' => 'absent') }
      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-namevar.yaml")
                            .with(
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "---\nbackupset:\n  namevar: {}\n",
                                 )
      }    
      it { is_expected.not_to contain_concat__fragment('backupset|namevar|/etc/rdbduprunner/conf.d/backupset-namevar.yaml') }
    end
    context "all params" do
      let(:params) do
        {
          'config_file' => "/etc/rdbduprunner/conf.d/backupset-not-namevar.yaml",
          'allowfs' => ['ext','ext2'],
          'backupdestination' => 'toaster',
          'checksum' => true,
          'disabled' => true,
          'duplicitybinary' => '/usr/local/bin/duplicity',
          'exclude' => '1',
          'excludes' => ['3','4',],
          'host' => 'example.com',
          'inplace' => false,
          'inventory' => true,
          'maxage' => '4d',
          'maxinc' => 4,
          'path' => ['/var/'],
          'paths' => ['/usr'],
          'postrun' => 'o',
          'prerun' => 'r',
          'rdiffbackupbinary' => '/usr/local/bin/rdiff-backup',
          'rsyncbinary' => '/local/rsync',
          'skip' => ['a'],
          'skips' => ['not','this'],
          'skipfstype' => 'zfs',
          'skipre' => ['4','3'],
          'skipres' => ['1','2'],
          'sshcompress' => true,
          'stats' => false,
          'rtag' => 'tickle',
          'trickle' => 5,
          'tricklebinary' => '/bin/trickle',
          'useagent' => true,
          'verbosity' => 5,
          'volsize' => 1000,
          'wholefile' => false,
          'zfsbinary' => '/usr/sbin/zfs',
        }
      end
      it { is_expected.to compile }
      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-not-namevar.conf")
                            .with('ensure' => 'absent') }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-not-namevar.yaml")
                            .with(
                              'owner'   => 'root',
                              'group'   => 0,
                              'mode'    => '0440',
                              'content' => "---
backupset:
  namevar:
    allowfs:
    - ext
    - ext2
    backupdestination: toaster
    checksum: true
    disabled: true
    duplicitybinary: \"/usr/local/bin/duplicity\"
    exclude:
    - '1'
    - '3'
    - '4'
    host: example.com
    inplace: false
    inventory: true
    maxage: 4d
    maxinc: 4
    path:
    - \"/usr\"
    - \"/var/\"
    postrun: o
    prerun: r
    rdiffbackupbinary: \"/usr/local/bin/rdiff-backup\"
    rsyncbinary: \"/local/rsync\"
    skip:
    - a
    - not
    - this
    skipfstype: zfs
    skipre:
    - '1'
    - '2'
    - '3'
    - '4'
    sshcompress: true
    stats: false
    tag: tickle
    trickle: 5
    tricklebinary: \"/bin/trickle\"
    useagent: true
    verbosity: 5
    volsize: 1000
    wholefile: false
    zfsbinary: \"/usr/sbin/zfs\"
")
      }
    end
    context "absent" do
      let(:params) do
        {
          'file_ensure' => 'absent'
        }
      end
      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-namevar.conf")
                            .with('ensure' => 'absent') }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-namevar.yaml")
                            .with('ensure' => 'absent') }
      
    end
  end
end
