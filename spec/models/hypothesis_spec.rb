require 'rails_helper'

RSpec.describe Hypothesis, type: :model do
  it 'has a valid factory' do
    expect(build(:hypothesis)).to be_valid
  end
end
