# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::configure' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include rdbduprunner' }

      it { is_expected.to compile }
      it { is_expected.to contain_concat('/etc/rdbduprunner.rc').with('owner' => 'root', 'group' => 0, 'mode' => '0440' ) }
      it { is_expected.to contain_concat__fragment('global options /etc/rdbduprunner.rc').with('target' => '/etc/rdbduprunner.rc', 'order' => '05').with_content('') }
      it { is_expected.to contain_concat__fragment('include conf.d').with('target' => '/etc/rdbduprunner.rc', 'order' => '99').with_content("<<include /etc/rdbduprunner/conf.d/*.conf>>\n") }
      it { is_expected.to contain_file('/etc/rdbduprunner/excludes').with('ensure' => 'directory', 'owner' => 'root', 'group' => 0, 'mode' => '0775', 'purge' => false) } 
      it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes').with('ensure' => 'directory', 'owner' => 'root', 'group' => 0, 'mode' => '0775', 'purge' => false) } 
      it { is_expected.to have_rbdduprunner__backupset_resource_count(0) }
      it { is_expected.to have_rbdduprunner__backupdestination_resource_count(0) }
      
    end
    let(:pre_condition) { 'class { rdbduprunner: owner => "bob", group => "jim" }' }

  end
  # context 'with class params' do
  #   let(:pre_condition) { "class { rdbduprunner:
  #     'backupsets' => { 'test' => { 'paths' => [ '/usr' ], 'prerun' => '/bin/true' } },
  #       'owner' => 'bob', 'group' => 'jim'
  #         }"}       
    
  #   it { should compile }
  #   it { is_expected.to contain_concat('/etc/rdbduprunner.rc').with('owner' => 'bob', 'group' => 'jim', 'mode' => '0440' ) }
  #   it { is_expected.to contain_file('/etc/rdbduprunner/excludes').with('ensure' => 'directory', 'owner' => 'bob', 'group' => 'jim', 'mode' => '0775', 'purge' => false) } 
  #   it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes').with('ensure' => 'directory', 'owner' => 'bob', 'group' => 'jim', 'mode' => '0775', 'purge' => false) }
  #   it { is_expected.not_to contain_rdbduprunner__backupset('test').with(
  #                             'config_file' => '/etc/rdbduprunner.rc',
  #                             'concat' => true,
  #                             'paths' => ['/usr'],
  #                             'prerun' => '/bin/true',
  #                           ) }
  # end
end
