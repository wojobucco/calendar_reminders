require 'spec_helper'

describe 'layouts/application.html.erb' do

  context "with an authenticated user" do
    let(:valid_user) { stub_model(User, id: 1, name: "foo", email: "foo@foo.com") }

    before(:each) do
      view.stub(:current_user).and_return(valid_user)
    end

    it "should show a link to the user's profile" do
      render
      expect(response).to match /href=".+profile"/
    end

    it "should show a link to the user's settings" do
      render
      expect(response).to match /href=".+settings"/
    end
  end

end
