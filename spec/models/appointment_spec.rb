require 'spec_helper'

describe Appointment do

  let!(:user) { User.create(id: 1, email: 'foo@foo.com', name: 'foo') }
  let!(:contact) { Contact.create(id: 1, phone_number: '412-444-4444', name: 'bar') }

  context "when a user has already created appointments" do
    let!(:apt_1) { Appointment.create(user_id: 1, start: 1.month.from_now, end: (1.month.from_now + 1.hour), contact_id: contact.id) }
    let!(:apt_2) { Appointment.create(user_id: 1, start: 2.month.from_now, end: (2.month.from_now + 1.hour), contact_id: contact.id) }

    before(:each) do
      apt_2.reminder_history_entries.create
      user.set_default_user_settings
    end

    it "should return a list of appointments for a given user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(2)
    end

    context "when an appointment has been deleted" do
      let!(:apt_deleted) { Appointment.create(user_id: 1, start: 2.month.from_now, end: (2.month.from_now + 1.hour), contact: contact, deleted: true) }

      describe ".undeleted" do
        it "should only return the appointments that haven't been deleted" do
          appointments = Appointment.where(user_id: 1).undeleted
          expect(appointments.count).to eq(2)
        end
      end

    end

    describe ".unreminded_upcoming" do
      before(:each) do
        Appointment.create(user_id: 1, start: 10.minutes.from_now, end: 1.hour.from_now, contact: contact)
      end

      it "should return the unreminded appointments" do
        appointments = Appointment.unreminded_upcoming
        expect(appointments.count).to eq(1)
      end

      it "should not return deleted appointments" do
        Appointment.create(user_id: 1, start: 20.minutes.from_now, end: 1.hour.from_now, contact: contact, deleted: true)

        appointments = Appointment.unreminded_upcoming
        expect(appointments.count).to eq(1)
      end

      it "should not return appointments outside the user's reminder advance time" do
        Appointment.create(user_id: 1, start: 2.hours.from_now, end: 3.hours.from_now, contact: contact)

        appointments = Appointment.unreminded_upcoming
        expect(appointments.count).to eq(1)
      end
    end
  end

  context "#valid?" do
    let(:valid_params) { { user_id: 1, start: 10.minutes.from_now, end: 1.hour.from_now, contact_id: 1 } }

    it "should not be valid without a contact" do
      apt = Appointment.new(valid_params.except(:contact_id))
      expect(apt).to_not be_valid
    end

    it "should not be valid without a user" do
      apt = Appointment.new(valid_params.except(:user_id))
      expect(apt).to_not be_valid
    end

    it "should not be valid without a start time" do
      apt = Appointment.new(valid_params.except(:start))
      expect(apt).to_not be_valid
    end

    it "should not be valid without an end time" do
      apt = Appointment.new(valid_params.except(:end))
      expect(apt).to_not be_valid
    end

    it "should be valid with all required fields" do
      apt = Appointment.new(valid_params)
      expect(apt).to be_valid
    end
  end

  context "when a user does not have any appointments created" do
    it "should not return any appointments for this user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(0)
    end
  end

  describe "#send_reminder" do
    let(:api_client) { double('api_client').as_null_object }
    let(:contact) { mock_model(Contact, id: 1, phone_number: "123-456-7890") }
    let(:user) { stub_model(User, id: 1) }

    subject do
      Appointment.new(user_id: 1, contact: contact, user: user, start: Time.now)
    end

    before(:each) do
      subject.stub(:twilio_api_client).and_return(api_client)
      subject.reminder_history_entries.stub(:create)
    end

    context "when a user has reached the monthly reminder limit" do
      before(:each) do
        user.stub(:reminders_sent_in_current_month).and_return(
          GlobalSetting::MAX_MONTHLY_REMINDERS_PER_USER)
      end

      it "should raise an error" do
        expect { subject.send_reminder }.to raise_error
      end

      it "should not send another reminder" do
        api_client.should_not_receive(:send_sms_message)   

        begin
          subject.send_reminder
        rescue => e
        end
      end
    end

    context "when a reminder has not yet been sent" do
      before(:each) do
        user.stub(:reminders_sent_in_current_month).and_return(0)
      end

      it "should send a reminder using the API client" do
        api_client.should_receive(:send_sms_message)   
        subject.send_reminder
      end

      it "should create a reminder history entry" do
        subject.reminder_history_entries.should_receive(:create)
        subject.send_reminder
      end
    
      context "when a user has a phone number set in their settings" do
        let(:phone_number) { '555-555-5555' }

        before(:each) do
          user.settings.create({ key: :phone_number, value: phone_number })
        end
        
        it "should include their phone number in the message", focus: true do
          api_client.should_receive(:send_sms_message).with(anything, /#{phone_number}/)
          subject.send_reminder
        end
      end
    end

    context "when a reminder has already been sent" do
      before(:each) do
        subject.stub(:reminder_sent?).and_return(true)
      end

      it "should raise an error" do
        expect { subject.send_reminder }.to raise_error
      end

      it "should not send another reminder" do
        api_client.should_not_receive(:send_sms_message)   

        begin
          subject.send_reminder
        rescue => e
        end
      end
    end

  end
end
