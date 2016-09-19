require 'rails_helper'

RSpec.describe "canvases/index", type: :view do
  before(:each) do
    assign(:canvases, [
      Canvas.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Canvas.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of canvases" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
