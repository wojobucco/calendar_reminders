require 'spec_helper'
require_relative 'request_spec_helper'

describe "Contacts" do
  include RequestSpecHelper

  describe "GET /contacts" do

    context "with an authenticated user" do

      before(:each) do
        login
      end

      it "displays index successfully" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get contacts_path
        response.status.should be(200)
      end

    end
  end
end
