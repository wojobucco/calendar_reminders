require 'spec_helper'

describe "appointments/new" do

  it "displays a newly created appointment" do
    assign(:appointment, stub_model(Appointment, user_id: 1))
    render
    expect(rendered).to match /New appointment/
  end

end
