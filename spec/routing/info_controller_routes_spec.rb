require 'spec_helper'

describe "routes for the info controller" do
  
  it "should route #about" do
    expect(:get => "/info/about").to route_to("info#about")
  end

  it "should route #contact" do
    expect(:get => "/info/contact").to route_to("info#contact")
  end

  it "should not route #foo" do
    expect(:get => "/info/foo").to_not be_routable
  end

end
