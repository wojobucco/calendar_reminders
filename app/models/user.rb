class User < ActiveRecord::Base
  has_many :appointments, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :settings, dependent: :destroy

  has_many :reminder_history_entries, through: :appointments

  validates :email, :name, presence: true

  def reminders_sent_in_current_month 
    reminder_history_entries.where("created_at > ?", current_month).count
  end

  def reminders_sent_all_time
    reminder_history_entries.count
  end

  def set_default_user_settings
    settings.each { |setting| setting.destroy }

    settings.create({ key: Setting::KEYS[:reminder_advance_time], value: 60, units: :minutes })
    settings.create({ key: Setting::KEYS[:phone_number] })
  end

  private

  def current_month
    now = Time.zone.now
    return Time.new(now.year, now.month, 1, 0, 0, 0, now.utc_offset)
  end

end
