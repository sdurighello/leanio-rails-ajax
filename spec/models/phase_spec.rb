require 'rails_helper'

RSpec.describe Phase, type: :model do
  it 'has a valid factory' do
    expect(build(:phase)).to be_valid
  end
end
