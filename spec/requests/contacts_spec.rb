require 'spec_helper'

describe "Contacts" do
  describe "GET /contacts" do

    context "with an authenticated user" do

      before(:each) do
        session['user_id'] = 1
        User.stub(:find).with(session['user_id']).and_return(double(User, id: 1))
      end

      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get contacts_path
        response.status.should be(200)
      end

    end
  end
end
