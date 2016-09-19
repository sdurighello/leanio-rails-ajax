require "rails_helper"

RSpec.describe CanvasesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/canvases").to route_to("canvases#index")
    end

    it "routes to #new" do
      expect(:get => "/canvases/new").to route_to("canvases#new")
    end

    it "routes to #show" do
      expect(:get => "/canvases/1").to route_to("canvases#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/canvases/1/edit").to route_to("canvases#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/canvases").to route_to("canvases#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/canvases/1").to route_to("canvases#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/canvases/1").to route_to("canvases#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/canvases/1").to route_to("canvases#destroy", :id => "1")
    end

  end
end
