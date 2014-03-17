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

  it "is valid without a value" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:phone_number], value: nil)
    expect(setting).to be_valid
  end

  it "is not valid without a user_id" do
    setting = Setting.new(user_id: nil, key: Setting::KEYS[:reminder_advance_time], value: "foo")
    expect(setting).to_not be_valid
  end

  it "is not valid without a key" do
    setting = Setting.new(user_id: 1, key: nil, value: "hello")
    expect(setting).to_not be_valid
  end

  it "is valid with a valid units" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:reminder_advance_time], value: 30, units: Setting::UNITS[:minutes])
    expect(setting).to be_valid
  end

  it "is valid with a nil units" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:reminder_advance_time], value: 30, units: nil)
    expect(setting).to be_valid
  end

  it "is not valid with an invalid units" do
    setting = Setting.new(user_id: 1, key: Setting::KEYS[:reminder_advance_time], value: 30, units: 'foo')
    expect(setting).to_not be_valid
  end
end
