require 'spec_helper'

describe AppointmentsController do

  describe "GET 'index'" do
    
    it "returns http success" do
      subject.stub(:authorize)
      GoogleApi.stub(:new).and_return(double('api').as_null_object)
      Calendar.stub(:find_all_calendars).and_return([])
      get 'index'
      response.should be_success
    end

  end

end
