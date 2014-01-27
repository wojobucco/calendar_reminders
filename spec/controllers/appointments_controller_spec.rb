require 'spec_helper'

describe AppointmentsController do

  describe "getting a list of appointments" do
    
    context "with an authenticated user" do

      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "returns http success" do
        get 'index'
        response.should be_success
      end

      context "with a user that has appointments" do

        let(:appointments) { [double(Appointment, user_id: 1)] }

        it "gets a list of appointments for the currently logged in user" do
          Appointment.should_receive(:where).with(user_id: 1).and_return(appointments)
          get 'index'
        end
      end
    end
  end

  describe "creating a new appointment" do

    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "creates a new appointment and presents it to the user" do
        Appointment.should_receive(:new).with(user_id: 1).and_return(double(Appointment, id: 1))
        get 'new'
      end
    end

  end

  describe "saving a newly created appointment" do

    let(:valid_params) { { start_date: '1/1/2014', start_time: '12:00:00 PM', duration: '60' } }

    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "redirects to the appointments list when the appointment is saved" do
        Appointment.should_receive(:create).with(user_id: 1, start: Time.parse('1/1/2014 12:00:00 PM'), 
          end: Time.parse('1/1/2014 1:00:00 PM')).and_return(double(Appointment, :persisted? => true))

        post 'create', valid_params
        expect(response).to redirect_to(appointments_path)
      end
    end

  end

  describe "destroying an appointment" do
    
    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "redirects to the appointments list when the appointment is deleted" do
        Appointment.stub(:find).and_return(stub_model(Appointment))

        delete 'destroy', id: 1
        expect(response).to redirect_to(appointments_path)
      end

      it "destroys the appointment" do
        apt = mock_model(Appointment, id: 1)
        apt.should_receive(:destroy)
        Appointment.stub(:find).and_return(apt)

        delete 'destroy', id: 1
      end
    end
  end
end
