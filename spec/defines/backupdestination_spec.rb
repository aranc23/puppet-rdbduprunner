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
                            .with( 'ensure'  => 'present',
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "<BackupDestination namevar>\n  Path /tmp/backup\n  Type rsync\n</BackupDestination>\n",
                                 )
      }    
    end
    context "concat" do
      let(:params) do
        super().merge({ 'concat' => true })
      end
      it { is_expected.to contain_concat__fragment('backupdestination/namevar//etc/rdbduprunner/conf.d/backupdestination-namevar.conf')
                            .with( 'target' => '/etc/rdbduprunner/conf.d/backupdestination-namevar.conf',
                                   'order' => '20-namevar',
                                   'content' => "<BackupDestination namevar>\n  Path /tmp/backup\n  Type rsync\n</BackupDestination>\n",
                                 )
      }    
    end
    context "all params" do
      let(:params) do
        super().merge(
        {
          'config_file' => "/etc/rdbduprunner/conf.d/backupdestination-not-namevar.conf",
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
                            .with( 'ensure'  => 'present',
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "<BackupDestination namevar>
  Path /tmp/backup
  Type rdiff-backup
  Inplace false
  Checksum true
  WholeFile false
  Stats true
  ZfsCreate false
  ZfsSnapshot true
  PercentUsed 5
  MinFree 22
  MaxInc 7
</BackupDestination>
")
      }    
      
    end
  end
end
