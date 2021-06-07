require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::packagemanager::lowlevel', type: :class do
    describe 'accepts a package manager' do
      [
        'dpkg',
        'rpm',
      ].each do |value|
        describe value.inspect do
          let(:params) { { value: value } }

          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        'invalid',
        123,
        ['rpm'],
      ].each do |value|
        describe value.inspect do
          let(:params) { { value: value } }

          it { is_expected.to compile.and_raise_error(%r{parameter 'value' }) }
        end
      end
    end
  end
end
