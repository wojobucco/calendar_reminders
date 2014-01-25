require 'spec_helper'

describe ContactsController do

  describe "index" do

    context "when the user is not logged in" do
      it "should redirect the user to the home page" do
        get "index"
        expect(response).to redirect_to('/')
      end
    end

  end
       
end
