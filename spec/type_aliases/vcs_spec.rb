require 'spec_helper'

describe 'Etckeeper::VCS' do
  it { is_expected.to allow_values('bzr', 'darcs', 'git', 'hg') }
  it { is_expected.not_to allow_values('invalid', 123, ['git']) }
end
