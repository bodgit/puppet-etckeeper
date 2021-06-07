require 'spec_helper'

describe 'Etckeeper::PackageManager::LowLevel' do
  it { is_expected.to allow_values('dpkg', 'rpm', 'pacman') }
  it { is_expected.not_to allow_values('invalid', 123, ['rpm']) }
end
