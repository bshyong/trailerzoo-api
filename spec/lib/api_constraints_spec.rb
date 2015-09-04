require 'rails_helper'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe "matches?" do
    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'dev.commonsenselabs.com',
                       headers: {"Accept" => "application/vnd.summonist.v1"})
      expect(api_constraints_v1.matches?(request)).to eql true
    end

    it "returns the default version when no header is passed" do
      request = double(host: 'dev.commonsenselabs.com')
      expect(api_constraints_v2.matches?(request)).to eql true
    end
  end
end
