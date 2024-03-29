# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('rdbduprunner::install') }
      it { is_expected.to contain_class('rdbduprunner::configure') }
      it { is_expected.to contain_class('rdbduprunner::service') }
      it { is_expected.to contain_file('/etc/cron.daily/rdbduprunner').
                            with('ensure' => 'present',
                                 'owner' => 'root',
                                 'group' => 0,
                                 'mode' => '0550',
                                 'content' => "#!/bin/sh\ntest -x /usr/bin/keychain && eval $( /usr/bin/keychain --eval --quiet ) ; /usr/bin/rdbduprunner --level info --notest >/dev/null 2>&1\n") }
      ['monthly','weekly','hourly','yearly'].each do |p|
        it { is_expected.to contain_file("/etc/cron.#{p}/rdbduprunner").
                              with('ensure' => 'absent') }
      end
      it { is_expected.to contain_file("/etc/cron.d/rdbduprunner").
                            with('ensure' => 'absent') }
      it { is_expected.to contain_cron('rdbduprunner').
                            with('ensure' => 'absent') }
      it { is_expected.to contain_file('/etc/logrotate.d/rdbduprunner').
                            with('ensure' => 'present',
                                 'owner' => 'root',
                                 'group' => 0,
                                 'mode' => '0644',
                                 'source' => 'puppet:///modules/rdbduprunner/logrotate.d/rdbduprunner',
                                ) }
      
    end
  end
  context 'with class params' do
    let(:params) do
      {
        'backupsets' => { 'namevar' => { 'paths' => [ '/usr' ], 'prerun' => '/bin/true' } },
        'backupdestinations' => { 'namevar' => { 'path' => '/tmp/backups', 'backup_type' => 'duplicity' } },
        'rsync_tag_excludes' => { 'some' => [ 'some', 'thing' ] },
        'rdbdup_tag_excludes' => { 'some' => [ 'some', 'other', 'thing' ],
                                   'other' => ['other','things'] },
        'owner' => "bob",
        'group' => "jim",
      }
    end

    it { should compile }
    # it is always called rdbduprunner now:
    it { is_expected.to contain_package('rdbduprunner') }
    it { is_expected.to contain_concat('/etc/rdbduprunner.rc').
                          with('owner' => 'bob', 'group' => 'jim', 'mode' => '0440' ) }
    it { is_expected.to contain_rdbduprunner__backupset('namevar')
                          .with('paths' => [ '/usr' ], 'prerun' => '/bin/true') }
    it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupset-namevar.conf') }
    it { is_expected.to contain_rdbduprunner__backupdestination('namevar')
                          .with('path' => '/tmp/backups', 'backup_type' => 'duplicity') }
    it { is_expected.to contain_file('/etc/rdbduprunner/conf.d/backupdestination-namevar.conf') }
    it { is_expected.to contain_file('/etc/rdbduprunner/excludes').
                          with('ensure' => 'directory', 'owner' => 'bob', 'group' => 'jim', 'mode' => '0775', 'purge' => false) } 
    it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes').
                          with('ensure' => 'directory', 'owner' => 'bob', 'group' => 'jim', 'mode' => '0775', 'purge' => false) }
    it { is_expected.to contain_file('/etc/rdbduprunner/excludes/some').
                          with('owner' => 'bob', 'group' => 'jim', 'mode' => '0664').
                          with_content("some\nthing\n") }
    it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes/some').
                          with('owner' => 'bob', 'group' => 'jim', 'mode' => '0644').
                          with_content("some\nother\nthing\n") }
    it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes/other').
                          with('owner' => 'bob', 'group' => 'jim', 'mode' => '0644').
                          with_content("other\nthings\n") }
    
  end
  context 'cron_method cron.d' do
    let(:params) do
      { 'cron_method' => 'cron.d',
        'cron_resource_name' => 'rdb',
        'cmd' => '/bin/true',
        'log_level' => 'debug',
        'minute' => 4,
        'hour' => 5,
        'monthday' => 6,
        'month' => 7,
        'weekday' => 0,
      }
    end

    it { should compile }
    ['daily','monthly','weekly','hourly','yearly'].each do |p|
      it { is_expected.to contain_file("/etc/cron.#{p}/rdb").
                            with('ensure' => 'absent') }
    end
    it { is_expected.to contain_file("/etc/cron.d/rdb").
                          with('ensure' => 'present',
                               'owner' => 'root',
                               'group' => 0,
                               'mode' => '0644',
                               'content' => "# Run rdbduprunner
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
4 5 6 7 0 root /bin/true
") }

    it { is_expected.to contain_cron('rdb').
                          with('ensure' => 'absent') }
  end

  context 'cron_method cron' do
    let(:params) do
      { 'cron_method' => 'cron',
        'executable' => '/usr/local/bin/rdbduprunner',
        'log_level' => 'debug',
        'minute' => 4,
        'hour' => 5,
        'monthday' => 6,
        'month' => 7,
        'weekday' => 0,
      }
    end

    it { should compile }
    ['daily','monthly','weekly','hourly','yearly'].each do |p|
      it { is_expected.to contain_file("/etc/cron.#{p}/rdbduprunner").
                            with('ensure' => 'absent') }
    end
    it { is_expected.to contain_file("/etc/cron.d/rdbduprunner").
                          with('ensure' => 'absent') }
    it { is_expected.to contain_cron('rdbduprunner').
                          with('ensure' => 'present',
                               'user' => 'root',
                               'hour' => 5,
                               'minute' => 4,
                               'monthday' => 6,
                               'month' => 7,
                               'weekday' => 0,
                               'command' => "test -x /usr/bin/keychain && eval $( /usr/bin/keychain --eval --quiet ) ; /usr/local/bin/rdbduprunner --level debug --notest >/dev/null 2>&1") }

  end
  ['daily','monthly','weekly','hourly','yearly'].each do |p|
    context "cron_method anacron #{p}" do
      let(:params) do
        { 'anacron_frequency' => p,
          'cron_method' => 'anacron',
        }
      end
      it { is_expected.to contain_file("/etc/cron.#{p}/rdbduprunner").
                            with('ensure' => 'present') }
    end
  end
end
