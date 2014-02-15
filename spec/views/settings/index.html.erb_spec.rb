require 'spec_helper'

describe 'settings/index.html.erb' do
  let(:valid_settings) { [
    stub_model(Setting, id: 1, user_id: 1, key: 0, value: "60")
    ] }

  it "shows the user's settings" do
    assign(:settings, valid_settings)

    render

    expect(rendered).to match /reminder_advance_time: 60/
  end

end
