require 'rails_helper'

RSpec.describe "areas/new", type: :view do
  before(:each) do
    assign(:area, Area.new(
      :name => "MyString",
      :description => "MyText",
      :area_identifier => "MyString"
    ))
  end

  it "renders new area form" do
    render

    assert_select "form[action=?][method=?]", areas_path, "post" do

      assert_select "input#area_name[name=?]", "area[name]"

      assert_select "textarea#area_description[name=?]", "area[description]"

      assert_select "input#area_area_identifier[name=?]", "area[area_identifier]"
    end
  end
end
