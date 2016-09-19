require 'rails_helper'

RSpec.describe "results/new", type: :view do
  before(:each) do
    assign(:result, Result.new(
      :level => 1,
      :comment => "MyText",
      :experiment => nil,
      :hypothesis => nil
    ))
  end

  it "renders new result form" do
    render

    assert_select "form[action=?][method=?]", results_path, "post" do

      assert_select "input#result_level[name=?]", "result[level]"

      assert_select "textarea#result_comment[name=?]", "result[comment]"

      assert_select "input#result_experiment_id[name=?]", "result[experiment_id]"

      assert_select "input#result_hypothesis_id[name=?]", "result[hypothesis_id]"
    end
  end
end
