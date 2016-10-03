require 'rails_helper'

RSpec.describe Experiment, type: :model do

  it 'has a valid factory' do
    expect(build(:experiment)).to be_valid
  end

end
