require 'spec_helper'

describe "contacts/index" do
  before(:each) do
    assign(:contacts, [
      stub_model(Contact,
        :name => "Name",
        :phone_number => "Phone Number"
      ),
      stub_model(Contact,
        :name => "Name",
        :phone_number => "Phone Number"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
  end
end
