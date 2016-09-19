require 'rails_helper'

RSpec.describe "Canvas", type: :request do
  describe "GET /canvases" do
    it "works! (now write some real specs)" do
      get canvases_path
      expect(response).to have_http_status(200)
    end
  end
end
