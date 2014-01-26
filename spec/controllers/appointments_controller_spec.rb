require 'spec_helper'

describe AppointmentsController do

  describe "GET 'index'" do
    
    context "with an authenticated user" do

      before(:each) do
        subject.stub(:authorize)
      end

      it "returns http success" do
        get 'index'
        response.should be_success
      end

    end

  end

end
