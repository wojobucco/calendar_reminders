require 'spec_helper'

describe Appointment do

  context "when a user has already created appointments" do
    let!(:user) { User.create(email: 'foo@foo.com', name: 'foo') }
    let!(:apt_1) { Appointment.create(user_id: 1, start: 1.month.from_now) }
    let!(:apt_2) { Appointment.create(user_id: 1, start: 2.month.from_now) }

    before(:each) do
      apt_2.reminder_history_entries.create
      user.set_default_user_settings
    end

    it "should return a list of appointments for a given user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(2)
    end

    context "when an appointment has been deleted" do
      let!(:apt_deleted) { Appointment.create(user_id: 1, start: 2.month.from_now, deleted: true) }

      it "scoped queries should not return deleted appointments" do
        appointments = Appointment.where(user_id: 1)
        expect(appointments.count).to eq(2)
      end

      it "unscoped queries should return deleted appointments" do
        appointments = Appointment.unscoped.where(user_id: 1)
        expect(appointments.count).to eq(3)
      end
    end

    describe ".unreminded_upcoming" do
      it "should return the unreminded appointments" do
        Appointment.create(user_id: 1, start: 10.minutes.from_now)
        appointments = Appointment.unreminded_upcoming
        expect(appointments.count).to eq(1)
      end
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
    let(:user) { mock_model(User, id: 1) }

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
