require 'rails_helper'

describe Api::V1::SessionsController do

  describe "POST #create" do

   before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do

      before(:each) do
        credentials = { username: @user.username, password: "password" }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:user]).to_not have_key(:password_digest)
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { username: @user.username, password: "invalidpassword" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid login"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryGirl.create :user
      @user.set_auth_token!
      request.headers['Authorization'] =  @user.auth_token
      delete :destroy
    end

    it "should set auth token to nil" do
      @user.reload
      expect(@user.auth_token).to eql nil
    end

    it { should respond_with 204 }

  end


end
