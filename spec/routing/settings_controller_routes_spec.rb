require 'spec_helper'

describe "routes for the settings controller" do

  it "should route #index" do
    expect(:get => "settings").to route_to("settings#index")
  end

end
