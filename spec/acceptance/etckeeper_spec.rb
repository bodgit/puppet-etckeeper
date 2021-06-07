require 'spec_helper_acceptance'

describe 'etckeeper' do
  it 'works with no errors' do
    pp = <<-EOS
      class { '::etckeeper':
        vcs_user_name  => 'Vagrant User',
        vcs_user_email => 'vagrant@example.com',
      }

      ::etckeeper::ignore { '#test':
        ensure => present,
      }

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::etckeeper']
      }
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe package('etckeeper') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/etckeeper/etckeeper.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644 }
  end

  describe file('/etc/.git'), unless: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 700 }
  end

  describe file('/etc/.bzr'), if: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 700 }
  end

  describe file('/etc/.git/config'), unless: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644 }
    its(:content) do
      is_expected.to match(%r{^ \s* name \s* = \s* Vagrant \s User $}x)
      is_expected.to match(%r{^ \s* email \s* = \s* vagrant@example\.com $}x)
    end
  end

  describe file('/etc/.gitignore'), unless: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644 }
    its(:content) { is_expected.to match(%r{^ \# \s end \s section .+ \r?\n \\\#test $}x) }
  end

  describe file('/etc/.bzrignore'), if: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 600 }
    its(:content) { is_expected.to match(%r{^ \# \s end \s section .+ \r?\n \#test $}x) }
  end

  describe command('etckeeper commit "Initial commit"') do
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe file('/etc/.etckeeper') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 700 }
  end

  describe command('cd /etc && git status'), unless: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(%r{nothing to commit}) }
  end

  describe command('cd /etc && bzr status'), if: (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to eq '' }
  end
end
