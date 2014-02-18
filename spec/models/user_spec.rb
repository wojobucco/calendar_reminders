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

  describe "#set_default_user_settings" do

    let(:valid_user) { User.create({ :email => "foo@foo.com", :refresh_token => "klasldfj", :google_id => "foo", :name => "foo"}) }

    it "saves the user" do
      valid_user.should_receive(:save)
      valid_user.set_default_user_settings
    end

    it "creates all settings with their default values" do
      valid_user.set_default_user_settings

      pending "expect needs a custom matcher"
      expect(valid_user.settings).to include(Setting.new(key: Setting::KEYS[:reminder_advance_time], value: 60))
    end

    it "destroys all existing settings before recreating default settings" do
      valid_user.settings.create(key: Setting::KEYS[:reminder_advance_time], value: 60)
      expect(valid_user.settings.count).to eq(1)

      valid_user.settings.stub(:build)
      valid_user.set_default_user_settings

      expect(valid_user.settings.count).to eq(0)
    end
  end
end
