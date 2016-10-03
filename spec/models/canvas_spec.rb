require 'rails_helper'

RSpec.describe Canvas, type: :model do

  it 'has a valid factory' do
    expect(build(:canvas)).to be_valid
  end

end
