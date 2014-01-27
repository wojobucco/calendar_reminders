require 'spec_helper'

describe "appointments/new" do

  it "displays 'New appointment'" do
    render
    expect(rendered).to match /New appointment/
  end

end
