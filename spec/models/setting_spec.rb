require 'spec_helper'

describe Setting do
  it "is valid with a valid key" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:reminder_advance_time], 
      value: "bar")
    expect(setting).to be_valid
  end

  it "is not valid without a valid key" do
    setting = Setting.new(user_id: 1, key: "foo", value: "bar")
    expect(setting).to_not be_valid
  end

  it "is not valid without a value" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:reminder_advance_time], value: nil)
    expect(setting).to_not be_valid
  end

  it "is not valid without a user_id" do
    setting = Setting.new(user_id: nil, key: Setting::KEYS[:reminder_advance_time], value: "foo")
    expect(setting).to_not be_valid
  end

  it "is not valid without a key" do
    setting = Setting.new(user_id: 1, key: nil, value: "hello")
    expect(setting).to_not be_valid
  end
end
