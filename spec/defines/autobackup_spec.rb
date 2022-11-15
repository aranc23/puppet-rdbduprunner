# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::autobackup' do
  # let(:facts) do
  #   { 'hostname' => 'example.com' }
  # end
  let(:title) { 'namevar' }
  let(:params) do
    { 'destination' => '/tmp/backup',
      #'host' => 'example.com',
    }
  end
  let(:pre_condition) { 'include rdbduprunner' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      
      it { is_expected.to compile }
      it { is_expected.not_to contain_concat('/etc/rdbduprunner/conf.d/namevar.conf') }
      it { is_expected.not_to contain_concat__fragment('comment in /etc/rdbduprunner/conf.d/namevar.conf') }
      it { is_expected.not_to contain_concat__fragment('empty line in /etc/rdbduprunner/conf.d/namevar.conf') }
      it { is_expected.to contain_rdbduprunner__backupdestination('namevar')
                            .with('backup_type' => 'rsync',
                                  'path'        => '/tmp/backup',
                                  'inplace'     => nil,
                                  'wholefile'   => false) }
      it { is_expected.not_to contain_concat__fragment('backupdestination/namevar//etc/rdbduprunner/conf.d/namevar.conf') }
      it { is_expected.not_to contain_file('/etc/rdbduprunner/conf.d/backupdestination-namevar.yaml') }
      it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupdestination-namevar.conf') }
      it { is_expected.to contain_rdbduprunner__backupset('autobackup')
                            .with('host' => 'foo',
                                  'rtag'              => nil,
                                  'disabled'          => nil,
                                  'backupdestination' => 'namevar',
                                  'inventory'         => true,
                                  'inplace'           => nil,
                                  'prerun'            => nil,
                                  'postrun'           => nil,
                                  'path'              => [],
                                  'skip'              => [ '/var/lib/mysql', '/var/lib/pgsql' ],
                                  'skipre'            => [ '^\/run\/media', '^\/var\/lib\/docker\/devicemapper' ],
                                  'exclude'           => [],
                                 )
      }
      it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupset-autobackup.yaml') }
      it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupset-autobackup.conf')
                            .with('ensure' => 'absent') }
      it { is_expected.to contain_file('/root/.rdbduprunner.rc')
                            .with('ensure' => 'absent') }
      it { is_expected.to contain_file('/etc/cron.daily/rdbduprunner_autobackup_namevar.sh')
                            .with('ensure' => 'absent')
      }
    end
  end
  context "all options" do
    let(:title) { 'sample' }
    let(:params) do
      { 'destination' => '/tmp/backup',
        'host' => 'example.com',
        'inplace' => false,
        'wholefile' => true,
        'backupdestination' => 'data',
        'rtag' => 'bad-idea',
        'disabled' => false,
        'inventory' => false,
        'prerun' => '/bin/true',
        'postrun' => '/bin/false',
        'paths' => ['/usr/bin'],
        'skips' => ['/test'],
        'skipres' => ['^/test'],
        'excludes' => ['.junk'],
      }
    end
    it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/sample.conf')
                          .with('ensure' => 'absent') }
    it { is_expected.not_to contain_concat__fragment('comment in /etc/rdbduprunner/conf.d/sample.conf') }
    it { is_expected.not_to contain_concat__fragment('empty line in /etc/rdbduprunner/conf.d/sample.conf') }
    it { is_expected.to contain_rdbduprunner__backupdestination('data')
                          .with('backup_type' => 'rsync',
                                'path'        => '/tmp/backup',
                                'inplace'     => false,
                                'wholefile'   => true) }
    it { is_expected.not_to contain_concat__fragment('backupdestination/data//etc/rdbduprunner/conf.d/sample.conf') }
    it { is_expected.not_to contain_file('/etc/rdbduprunner/conf.d/backupdestination-data.yaml') }
    it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupdestination-data.conf') }

    it { is_expected.to contain_rdbduprunner__backupset('autobackup')
                          .with('host' => 'example.com',
                                'rtag'              => 'bad-idea',
                                'disabled'          => false,
                                'backupdestination' => 'data',
                                'inventory'         => false,
                                'inplace'           => false,
                                'prerun'            => '/bin/true',
                                'postrun'           => '/bin/false',
                                'path'              => ['/usr/bin'],
                                'skip'              => [ '/test', '/var/lib/mysql', '/var/lib/pgsql' ].sort,
                                'skipre'            => [ '^/test', '^\/run\/media', '^\/var\/lib\/docker\/devicemapper' ].sort,
                                'exclude'           => ['.junk'],
                               )
    }
  end
end
