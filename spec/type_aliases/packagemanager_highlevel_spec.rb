require 'spec_helper'

describe 'Etckeeper::PackageManager::HighLevel' do
  it { is_expected.to allow_values('apt', 'yum', 'zypper', 'pacman') }
  it { is_expected.not_to allow_values('invalid', 123, ['yum']) }
end
