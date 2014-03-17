require 'spec_helper'
require_relative 'helpers/user_helpers'

describe User do

  include Helpers::UserHelpers

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

    it "creates a reminder_advance_time setting set to 60 minutes" do
      valid_user.set_default_user_settings

      setting = get_setting_by_key(valid_user.settings, :reminder_advance_time)

      expect(setting).to_not be_nil
      expect(setting.value).to eq(60)
      expect(setting.units).to eq(:minutes.to_s)
    end

    it "creates a phone_number setting set to nil" do
      valid_user.set_default_user_settings

      setting = get_setting_by_key(valid_user.settings, :phone_number)

      expect(setting).to_not be_nil
      expect(setting.value).to be_nil
      expect(setting.units).to be_nil
    end
    
    it "destroys all existing settings before recreating default settings" do
      valid_user.settings.create(key: Setting::KEYS[:reminder_advance_time], value: 60)
      expect(valid_user.settings.count).to eq(1)

      valid_user.settings.stub(:create)
      valid_user.set_default_user_settings

      expect(valid_user.settings.count).to eq(0)
    end
  end
end
