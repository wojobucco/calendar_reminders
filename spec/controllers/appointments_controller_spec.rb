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
        
        let(:upcoming_appointments) { [double(Appointment, user_id: 1, start: (Time.now + 1.days))] }
        let(:past_appointments) { [double(Appointment, user_id: 1, start: (Time.now - 1.days))] }
        let(:all_appointments) { upcoming_appointments | past_appointments }

        context "when no filter is set" do
          it "gets a list of the upcoming appointments for the user" do
            Appointment.should_receive(:upcoming).and_return(upcoming_appointments)
            get('index')
            expect(assigns(:appointments)).to eq(upcoming_appointments)
          end
        end

        context "when the all filter is set" do
          it "gets a list of all appointments for the currently logged in user" do
            all_appointments.stub(:undeleted).and_return(all_appointments)
            Appointment.should_receive(:where).with(user_id: 1).and_return(all_appointments)
            get('index', { filter: :all })
            expect(assigns(:appointments)).to eq(all_appointments)
          end
        end

        context "when the upcoming filter is set" do
          it "gets a list of only the upcoming appointments for the currently logged in user" do
            Appointment.should_receive(:upcoming).and_return(upcoming_appointments)
            get('index', { filter: :upcoming })
            expect(assigns(:appointments)).to eq(upcoming_appointments)
          end
        end

        context "when the past filter is set" do
          it "gets a list of only the past appointments for the currently logged in user" do
            Appointment.should_receive(:past).and_return(past_appointments)
            get('index', { filter: :past })
            expect(assigns(:appointments)).to eq(past_appointments)
          end
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

      it "responds succesfully" do
        get 'new'
        expect(response).to be_success
      end
    end

  end

  describe "saving a newly created appointment" do

    let(:valid_params) { { start_date: '1/1/2014', start_time: '12:00:00 PM', 
      duration: '60', appointment: { contact_id: 1 } } }

    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      context "with all required parameters supplied" do

        it "redirects to the appointments list when the appointment is saved" do
          Appointment.should_receive(:create).with(start: Time.parse('1/1/2014 12:00:00 PM'), 
            end: Time.parse('1/1/2014 1:00:00 PM'), contact_id: '1', user_id: 1).and_return(double(Appointment, :persisted? => true))

          post 'create', valid_params
          expect(response).to redirect_to(appointments_path)
        end

      end

      context "without all required parameters supplied" do
        it "should flash the error message" do
          post "create", valid_params.except(:appointment)
          expect(flash.now[:error]).to_not be_nil
        end

        it "should re-render the create page" do
          post "create", valid_params.except(:appointment)
          expect(response).to render_template(:new)
        end
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

      it "does a soft delete of the appointment" do
        apt = stub_model(Appointment, id: 1)
        apt.should_receive(:delete)
        Appointment.stub(:find).and_return(apt)

        delete 'destroy', id: 1
      end

      it "does not destroy the appointment" do
        apt = stub_model(Appointment, id: 1)
        apt.should_not_receive(:destroy)
        Appointment.stub(:find).and_return(apt)

        delete 'destroy', id: 1
      end
    end
  end

  describe "editing an appointment" do

    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "retrieves the appointment" do
        Appointment.should_receive(:find).with(1).and_return(stub_model(Appointment))

        get 'edit', id: 1
      end

      it "assigns the @appointment instance variable" do
        apt = stub_model(Appointment)
        Appointment.should_receive(:find).with(1).and_return(apt)

        get 'edit', id: 1
        expect(assigns(:appointment)).to eq(apt)
      end
    end

  end


  describe "updating  an appointment" do
    
    context "with an authenticated user" do
      before(:each) do
        subject.stub(:authorize)
        subject.stub(:current_user).and_return(mock_model(User, id: 1))
      end

      it "redirects to the appointments list when the appointment is saved" do
        Appointment.stub(:find).and_return(stub_model(Appointment))

        put 'update', id: 1, start_date: '1/1/2014', start_time: '12:00:00 PM', duration: '90'
        expect(response).to redirect_to(appointments_path)
      end

      it "renders the edit form if the save was unsuccessful" do
        apt = mock_model(Appointment).as_null_object
        apt.should_receive(:persisted?).and_return(false)
        Appointment.stub(:find).and_return(apt)

        put 'update', id: 1, start_date: '1/1/2014', start_time: '12:00:00 PM', duration: '90'
        expect(response).to render_template(:edit)
      end

      it "retrieves the appointment" do
        Appointment.should_receive(:find).with(1).and_return(stub_model(Appointment))

        patch 'update', id: 1
      end
    end

  end
end
