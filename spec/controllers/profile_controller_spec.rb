require 'spec_helper'

describe ProfileController do

  context "when the user is authorized" do
    let(:valid_user) { stub_model(User, id: 1, name: "foo", email: "foo@foo.com") }

    before(:each) do
      subject.stub(:authorize)
      subject.stub(:current_user).and_return(valid_user)
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  end

  context "when the user is not authorized" do
    it "should redirect" do
      get 'index'
      expect(response).to be_redirect
    end
  end
end
