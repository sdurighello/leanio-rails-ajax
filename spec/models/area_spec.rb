require 'rails_helper'

RSpec.describe Area, type: :model do

  it 'has a valid factory' do
    expect(build(:area)).to be_valid
  end

end
