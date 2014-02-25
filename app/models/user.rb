class User < ActiveRecord::Base
  has_many :appointments, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :settings, dependent: :destroy

  validates :email, :name, presence: true

  def set_default_user_settings
    settings.each { |setting| setting.destroy }

    settings.build(
      { key: Setting::KEYS[:reminder_advance_time], value: 60, units: :minutes }
    )

    save
  end

  def reminder_advance_time
    setting = settings.where(key: :reminder_advance_time).take

    case setting.units.to_sym
      when :minutes
        setting.value.to_i
      when :hours
        setting.value.to_i * 60
      when :days
        setting.value.to_i * 60 * 24
      else
        raise StandardError "Invalid setting value/units"
    end
  end
end
