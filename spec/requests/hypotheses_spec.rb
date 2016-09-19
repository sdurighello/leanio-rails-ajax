require 'rails_helper'

RSpec.describe "Hypotheses", type: :request do
  describe "GET /hypotheses" do
    it "works! (now write some real specs)" do
      get hypotheses_path
      expect(response).to have_http_status(200)
    end
  end
end
