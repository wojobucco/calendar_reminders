require 'spec_helper'

describe "contacts/new" do
  before(:each) do
    assign(:contact, stub_model(Contact,
      :name => "MyString",
      :phone_number => "MyString"
    ).as_new_record)
  end

  it "renders new contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contacts_path, "post" do
      assert_select "input#contact_name[name=?]", "contact[name]"
      assert_select "input#contact_phone_number[name=?]", "contact[phone_number]"
    end
  end
end
