# frozen_string_literal: true

require 'spec_helper'

describe 'rdbduprunner::backup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { 'paths' => {'/usr' => ['local'] },
          'destination' => '/tmp/backups',
        }
      end
      let(:pre_condition) { 'include rdbduprunner' }

      it { is_expected.to compile }
    end
  end
end