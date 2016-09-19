require 'rails_helper'

RSpec.describe "results/index", type: :view do
  before(:each) do
    assign(:results, [
      Result.create!(
        :level => 2,
        :comment => "MyText",
        :experiment => nil,
        :hypothesis => nil
      ),
      Result.create!(
        :level => 2,
        :comment => "MyText",
        :experiment => nil,
        :hypothesis => nil
      )
    ])
  end

  it "renders a list of results" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
