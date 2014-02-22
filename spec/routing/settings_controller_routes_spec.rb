require 'spec_helper'

describe "routes for the settings controller" do

  it "should route #index" do
    expect(:get => "settings").to route_to("settings#index")
  end

  it "should route #update" do
    expect(:put => "settings/2").to route_to("settings#update", id: "2")
  end

end
