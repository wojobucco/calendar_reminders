require 'spec_helper'

describe "routes for the appointments controller" do

  it "should route to index" do
    expect(:get => appointments_path).to route_to("appointments#index")
  end

  it "should route to new" do
    expect(:get => new_appointment_path).to route_to("appointments#new")
  end

  it "should route to create" do
    expect(:post => appointments_path).to route_to("appointments#create")
  end

  it "should route to destroy" do
    expect(:delete => appointment_path(1)).to route_to(
     controller: "appointments", action: "destroy", id: '1') 
  end

  it "should route to send_reminder" do
    expect(:post => send_reminder_appointment_path(1)).to route_to(
      controller: "appointments", action: "send_reminder", id: '1')
  end
end
