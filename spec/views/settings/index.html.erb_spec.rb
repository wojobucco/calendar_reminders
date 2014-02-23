require 'spec_helper'

describe 'settings/index.html.erb' do
  let(:valid_settings) { [
    stub_model(Setting, id: 1, user_id: 1, key: 0, value: "60", units: Setting::UNITS[:minutes])
    ] }

  it "shows the user's settings" do
    assign(:settings, valid_settings)

    render

    expect(rendered).to match /Reminder advance time/
  end
end
