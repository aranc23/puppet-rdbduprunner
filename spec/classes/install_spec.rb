# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include rdbduprunner' }

      it { is_expected.to compile }
      it { is_expected.to contain_package('rdbduprunner') }
    end
  end
end
