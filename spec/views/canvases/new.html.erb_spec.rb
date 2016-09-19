require 'rails_helper'

RSpec.describe "canvases/new", type: :view do
  before(:each) do
    assign(:canvas, Canvas.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new canvas form" do
    render

    assert_select "form[action=?][method=?]", canvases_path, "post" do

      assert_select "input#canvas_name[name=?]", "canvas[name]"

      assert_select "textarea#canvas_description[name=?]", "canvas[description]"
    end
  end
end
