class AddDefaultPhoneNumberSettingForUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      phone_number_setting = user.settings.select { |s| s.key == :phone_number.to_s }.first

      if phone_number_setting.nil?
        user.settings.create({ key: Setting::KEYS[:phone_number] })
      end
    end
  end
end
