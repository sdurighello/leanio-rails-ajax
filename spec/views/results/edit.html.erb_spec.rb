require 'rails_helper'

RSpec.describe "results/edit", type: :view do
  before(:each) do
    @result = assign(:result, Result.create!(
      :level => 1,
      :comment => "MyText",
      :experiment => nil,
      :hypothesis => nil
    ))
  end

  it "renders the edit result form" do
    render

    assert_select "form[action=?][method=?]", result_path(@result), "post" do

      assert_select "input#result_level[name=?]", "result[level]"

      assert_select "textarea#result_comment[name=?]", "result[comment]"

      assert_select "input#result_experiment_id[name=?]", "result[experiment_id]"

      assert_select "input#result_hypothesis_id[name=?]", "result[hypothesis_id]"
    end
  end
end
