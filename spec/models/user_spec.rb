require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should respond_to(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:username) }

  describe "#set_auth_token" do
    it "generates a unique auth token" do
      allow(@user).to receive(:generate_auth_token) { "token"}
      @user.set_auth_token!
      expect(@user.auth_token).to eql "token"
    end
    it "does not generate the same token for multiple users" do
      existing_user = FactoryGirl.create(:user)
      existing_user.set_auth_token!
      @user.set_auth_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  it { should be_valid }
end
