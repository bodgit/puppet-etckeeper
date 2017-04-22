require 'spec_helper_acceptance'

describe 'etckeeper' do

  it 'should work with no errors' do

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

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe package('etckeeper') do
    it { should be_installed }
  end

  describe file('/etc/etckeeper/etckeeper.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe file('/etc/.git'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
  end

  describe file('/etc/.bzr'), :if => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
  end

  describe file('/etc/.git/config'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /^ \s* name \s* = \s* Vagrant \s User $/x }
    its(:content) { should match /^ \s* email \s* = \s* vagrant@example\.com $/x }
  end

  describe file('/etc/.gitignore'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /^ \# \s end \s section .+ \r?\n \\\#test $/x }
  end

  describe file('/etc/.bzrignore'), :if => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /^ \# \s end \s section .+ \r?\n \#test $/x }
  end

  describe command('etckeeper commit "Initial commit"') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/.etckeeper') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
  end

  describe command('cd /etc && git status'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /nothing to commit/ }
  end

  describe command('cd /etc && bzr status'), :if => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should eq '' }
  end
end
