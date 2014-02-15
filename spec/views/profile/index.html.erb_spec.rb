require 'spec_helper'

describe 'profile/index.html.erb' do
  
  let(:valid_user) { stub_model(User, id: 1, email: "foo@foo.com", refresh_token: "09820934823094",
      created_at: Time.now.to_s, updated_at: Time.now.to_s, google_id: "08098234234", name: "fooey") }

  it "shows the user's profile information" do
    assign(:user, valid_user)

    render

    expect(rendered).to match /foo@foo.com/
    expect(rendered).to match /fooey/
  end

end
