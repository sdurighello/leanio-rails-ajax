require 'rails_helper'

RSpec.describe "areas/index", type: :view do
  before(:each) do
    assign(:areas, [
      Area.create!(
        :name => "Name",
        :description => "MyText",
        :area_identifier => "Area Identifier"
      ),
      Area.create!(
        :name => "Name",
        :description => "MyText",
        :area_identifier => "Area Identifier"
      )
    ])
  end

  it "renders a list of areas" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Area Identifier".to_s, :count => 2
  end
end
