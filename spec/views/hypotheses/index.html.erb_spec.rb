require 'rails_helper'

RSpec.describe "hypotheses/index", type: :view do
  before(:each) do
    assign(:hypotheses, [
      Hypothesis.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Hypothesis.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of hypotheses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
