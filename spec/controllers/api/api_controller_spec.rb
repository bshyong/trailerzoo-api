require 'rails_helper'

RSpec.describe Api::ApiController, type: :controller do
  let(:api_controller) { Api::ApiController.new }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      @user.set_auth_token!
      request.headers["Authorization"] = @user.auth_token
      allow(api_controller).to receive(:request) { request }
    end
    it "returns the user from the authorization header" do
      expect(api_controller.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#authenticate_with_token" do
    before do
      allow(api_controller).to receive(:current_user) { nil }
      allow(response).to receive(:response_code) { 401 }
      allow(response).to receive(:body) { {"errors" => "Not authenticated"}.to_json }
      allow(api_controller).to receive(:response) { response }
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it { expect(response.response_code).to eql 401 }
  end

end
