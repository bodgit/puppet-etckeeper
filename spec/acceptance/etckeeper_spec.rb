require 'spec_helper_acceptance'

describe 'etckeeper' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::etckeeper

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

  describe file('/etc/.etckeeper'), :if => fact('osfamily').eql?('RedHat') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
  end

  describe file('/etc/.etckeeper'), :if => fact('osfamily').eql?('Debian') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
  end

  describe command('git config --global user.email "vagrant@example.com"'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { should eq 0 }
  end

  describe command('git config --global user.name "Vagrant User"'), :unless => (fact('operatingsystem').eql?('Ubuntu') and fact('operatingsystemrelease').eql?('14.04')) do
    its(:exit_status) { should eq 0 }
  end

  describe command('etckeeper commit "Initial commit"') do
    its(:exit_status) { should eq 0 }
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
