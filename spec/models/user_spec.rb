require 'spec_helper'

describe User do

  it "should not be valid without an email" do
    user = User.new({ :email => nil, :refresh_token => "klasldfj", :google_id => "foo", :name => "foo"})
    expect(user).to_not be_valid
  end

  it "should not be valid without a name" do
    user = User.new({ :email => "foo@foo.com", :refresh_token => "klasldfj", :google_id => "foo", :name => nil})
    expect(user).to_not be_valid
  end

  it "should be valid with all fields supplied" do
    user = User.new({ :email => "foo@foo.com", :refresh_token => "klasldfj", :google_id => "foo", :name => "foo"})
    expect(user).to be_valid
  end

end
