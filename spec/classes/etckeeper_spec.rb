require 'spec_helper'

describe 'etckeeper' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'managing the VCS package' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('etckeeper') }
        it { is_expected.to contain_class('etckeeper::config') }
        it { is_expected.to contain_class('etckeeper::install') }
        it { is_expected.to contain_exec('etckeeper init') }
        it { is_expected.to contain_file('/etc/_darcs').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hg').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hgignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/etckeeper') }
        it { is_expected.to contain_file('/etc/etckeeper/etckeeper.conf') }
        it { is_expected.to contain_package('etckeeper') }

        if facts[:operatingsystem].eql?('Ubuntu') && facts[:operatingsystemrelease].eql?('14.04')
          it { is_expected.to contain_file('/etc/.git').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.gitignore').with_ensure('absent') }
          it { is_expected.to contain_package('bzr') }
          it { is_expected.not_to contain_package('git') }
        else
          it { is_expected.to contain_file('/etc/.bzr').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.bzrignore').with_ensure('absent') }
          it { is_expected.not_to contain_package('bzr') }
          it { is_expected.to contain_package('git') }
        end

        it { is_expected.not_to contain_package('darcs') }
        it { is_expected.not_to contain_package('hg') }
      end

      context 'not managing the VCS package' do
        let(:params) do
          {
            manage_vcs_package: false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('etckeeper') }
        it { is_expected.to contain_class('etckeeper::config') }
        it { is_expected.to contain_class('etckeeper::install') }
        it { is_expected.to contain_exec('etckeeper init') }
        it { is_expected.to contain_file('/etc/_darcs').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hg').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hgignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/etckeeper') }
        it { is_expected.to contain_file('/etc/etckeeper/etckeeper.conf') }
        it { is_expected.not_to contain_package('bzr') }
        it { is_expected.to contain_package('etckeeper') }
        it { is_expected.not_to contain_package('git') }
        it { is_expected.not_to contain_package('darcs') }
        it { is_expected.not_to contain_package('hg') }

        if facts[:operatingsystem].eql?('Ubuntu') && facts[:operatingsystemrelease].eql?('14.04')
          it { is_expected.to contain_file('/etc/.git').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.gitignore').with_ensure('absent') }
        else
          it { is_expected.to contain_file('/etc/.bzr').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.bzrignore').with_ensure('absent') }
        end
      end

      context 'forcing the user name & email' do
        let(:params) do
          {
            vcs_user_name:  'Alice',
            vcs_user_email: 'alice@example.com',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('etckeeper') }
        it { is_expected.to contain_class('etckeeper::config') }
        it { is_expected.to contain_class('etckeeper::install') }
        it { is_expected.to contain_exec('etckeeper init') }
        it { is_expected.to contain_file('/etc/_darcs').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hg').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/.hgignore').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/etckeeper') }
        it { is_expected.to contain_file('/etc/etckeeper/etckeeper.conf') }
        it { is_expected.to contain_package('etckeeper') }

        if facts[:operatingsystem].eql?('Ubuntu') && facts[:operatingsystemrelease].eql?('14.04')
          it { is_expected.to contain_file('/etc/.git').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.gitignore').with_ensure('absent') }
          it { is_expected.to contain_package('bzr') }
          it { is_expected.not_to contain_package('git') }
        else
          it { is_expected.to contain_file('/etc/.bzr').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.bzrignore').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/.git/config') }
          it { is_expected.to contain_ini_setting('/etc/.git/config user.email') }
          it { is_expected.to contain_ini_setting('/etc/.git/config user.name') }
          it { is_expected.not_to contain_package('bzr') }
          it { is_expected.to contain_package('git') }
        end

        it { is_expected.not_to contain_package('darcs') }
        it { is_expected.not_to contain_package('hg') }
      end
    end
  end
end
