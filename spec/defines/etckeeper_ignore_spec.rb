require 'spec_helper'

describe 'etckeeper::ignore' do
  let(:title) do
    '#test'
  end

  let(:params) do
    {
      :ensure => 'present',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without etckeeper class included' do
        it { expect { should compile }.to raise_error(/must include the etckeeper base class/) }
      end

      context 'with etckeeper class included', :compile do
        let(:pre_condition) do
          'include ::etckeeper'
        end

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystem]
          when 'Ubuntu'
            case facts[:operatingsystemrelease]
            when '14.04'
              it { should contain_file_line('/etc/.bzrignore #test').with_line('#test') }
            else
              it { should contain_file_line('/etc/.gitignore #test').with_line('\#test') }
            end
          else
            it { should contain_file_line('/etc/.gitignore #test').with_line('\#test') }
          end
        when 'RedHat'
          it { should contain_file_line('/etc/.gitignore #test').with_line('\#test') }
        end
      end
    end
  end
end
