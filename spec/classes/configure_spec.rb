# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::configure' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include rdbduprunner' }

      it { is_expected.to compile }
      it { is_expected.not_to contain_concat('/etc/rdbduprunner.rc') }
      it { is_expected.to contain_file('/etc/rdbduprunner.rc')
                            .with('ensure' => 'absent',
                                  'backup' => true) }
      it { is_expected.to contain_file('/root/.rdbduprunner.rc')
                            .with('ensure' => 'absent',
                                  'backup' => true) }
      it { is_expected.to contain_file('/etc/rdbduprunner/rdbduprunner.yaml' ) }
      it { is_expected.not_to contain_concat__fragment('include conf.d') }
      it { is_expected.to contain_file('/etc/rdbduprunner/excludes')
                            .with('ensure' => 'directory', 'owner' => 'root', 'group' => 0, 'mode' => '0775', 'purge' => false) } 
      it { is_expected.to contain_file('/etc/rdbduprunner/rdb-excludes')
                            .with('ensure' => 'directory', 'owner' => 'root', 'group' => 0, 'mode' => '0775', 'purge' => false) } 
      it { is_expected.to have_rbdduprunner__backupset_resource_count(0) }
      it { is_expected.to have_rbdduprunner__backupdestination_resource_count(0) }

    end
  end
end
