require 'spec_helper'

describe ProfileController do

  context "when the user is authorized" do
    before(:each) do
      subject.stub(:authorize)
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', id: 1
        response.should be_success
      end
    end
  end

  context "when the user is not authorized" do
    it "should redirect" do
      get 'show', id: 1
      expect(response).to be_redirect
    end
  end
end
