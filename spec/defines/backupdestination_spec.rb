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
    end
  end
end
