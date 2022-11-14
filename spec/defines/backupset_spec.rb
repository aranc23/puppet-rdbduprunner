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
                            .with( 'ensure'  => 'present',
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "<BackupSet namevar>\n</BackupSet>\n",
                                 )
      }    
    end
    context "concat" do
      let(:params) do
        { 'concat' => true }
      end
      it { is_expected.to contain_concat__fragment('backupset|namevar|/etc/rdbduprunner/conf.d/backupset-namevar.conf')
                            .with( 'target' => '/etc/rdbduprunner/conf.d/backupset-namevar.conf',
                                   'order' => '30-namevar',
                                   'content' => "<BackupSet namevar>\n</BackupSet>\n",
                                 )
      }    
    end
    context "all params" do
      let(:params) do
        {
          'config_file' => "/etc/rdbduprunner/conf.d/backupset-not-namevar.conf",
          'host' => 'example.com',
          'paths' => ['/usr','/var/'],
          'skips' => ['not','this'],
          'skipres' => ['1','2'],
          'excludes' => ['3','4',],
          'allowfs' => ['ext','ext2'],
          'backupdestination' => 'toaster',
          'inventory' => true,
          'inplace' => false,
          'checksum' => true,
          'wholefile' => false,
          'stats' => true,
          'prerun' => 'r',
          'postrun' => 'o',
          'rtag' => 'tickle',
          'disabled' => true,
          'maxinc' => 4,
        }
      end
      it { is_expected.to compile }

      it { is_expected.to contain_file("/etc/rdbduprunner/conf.d/backupset-not-namevar.conf")
                            .with( 'ensure'  => 'present',
                                   'owner'   => 'root',
                                   'group'   => 0,
                                   'mode'    => '0440',
                                   'content' => "<BackupSet namevar>
  BackupDestination toaster
  Disabled true
  PreRun r
  PostRun o
  Host example.com
  Inventory true
  Tag tickle
  Inplace false
  Path /usr
  Path /var/
  Exclude 3
  Exclude 4
  SkipRE 1
  SkipRE 2
  Skip not
  Skip this
  AllowFS ext
  AllowFS ext2
  MaxInc 4
</BackupSet>
")
      }    
      
    end
  end
end
