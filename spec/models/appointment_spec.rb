require 'spec_helper'

describe Appointment do

  context "when a user has already created appointments" do
    before(:each) do
      Appointment.create(user_id: 1)
      Appointment.create(user_id: 1)
    end

    it "should return a list of appointments for a given user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(2)
    end
  end

  context "when a user does not have any appointments created" do

    it "should not return any appointments for this user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(0)
    end
 
  end
end
