require 'rails_helper'

RSpec.describe "hypotheses/edit", type: :view do
  before(:each) do
    @hypothesis = assign(:hypothesis, Hypothesis.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit hypothesis form" do
    render

    assert_select "form[action=?][method=?]", hypothesis_path(@hypothesis), "post" do

      assert_select "input#hypothesis_name[name=?]", "hypothesis[name]"

      assert_select "textarea#hypothesis_description[name=?]", "hypothesis[description]"
    end
  end
end
