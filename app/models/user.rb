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

end
