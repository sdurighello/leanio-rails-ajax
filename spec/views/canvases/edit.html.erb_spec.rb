require 'rails_helper'

RSpec.describe "canvases/edit", type: :view do
  before(:each) do
    @canvas = assign(:canvas, Canvas.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit canvas form" do
    render

    assert_select "form[action=?][method=?]", canvas_path(@canvas), "post" do

      assert_select "input#canvas_name[name=?]", "canvas[name]"

      assert_select "textarea#canvas_description[name=?]", "canvas[description]"
    end
  end
end
