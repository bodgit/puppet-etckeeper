require 'spec_helper'

describe 'etckeeper::ignore' do
  let(:title) do
    '#test'
  end

  let(:params) do
    {
      ensure: 'present',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without etckeeper class included' do
        it { is_expected.to compile.and_raise_error(%r{must include the etckeeper base class}) }
      end

      context 'with etckeeper class included' do
        let(:pre_condition) do
          'include ::etckeeper'
        end

        it { is_expected.to compile.with_all_deps }

        if facts[:operatingsystem].eql?('Ubuntu') && facts[:operatingsystemrelease].eql?('14.04')
          it { is_expected.to contain_file_line('/etc/.bzrignore #test').with_line('#test') }
        else
          it { is_expected.to contain_file_line('/etc/.gitignore #test').with_line('\#test') }
        end
      end
    end
  end
end
