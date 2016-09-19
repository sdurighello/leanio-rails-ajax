require "rails_helper"

RSpec.describe HypothesesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hypotheses").to route_to("hypotheses#index")
    end

    it "routes to #new" do
      expect(:get => "/hypotheses/new").to route_to("hypotheses#new")
    end

    it "routes to #show" do
      expect(:get => "/hypotheses/1").to route_to("hypotheses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hypotheses/1/edit").to route_to("hypotheses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hypotheses").to route_to("hypotheses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hypotheses/1").to route_to("hypotheses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hypotheses/1").to route_to("hypotheses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hypotheses/1").to route_to("hypotheses#destroy", :id => "1")
    end

  end
end
