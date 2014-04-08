require_relative '../services/twilio_api'

class Appointment < ActiveRecord::Base

  belongs_to :user
  belongs_to :contact

  has_many :reminder_history_entries, dependent: :destroy
  has_many :settings, through: :user

  validates_presence_of :user, :contact, :start, :end

  scope :upcoming, -> { where("start > ?", Time.now) }
  scope :past, -> { where("start < ?", Time.now) }

  scope :undeleted, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def delete
    self.update_attributes(:deleted => true)
  end

  def send_reminder
    if self.reminder_sent?
      raise StandardError.new "Cannot send reminder. A reminder was already sent for this appointment."
    elsif self.user.reminders_sent_in_current_month >= GlobalSetting::MAX_MONTHLY_REMINDERS_PER_USER
      raise StandardError.new "Cannot send reminder. User has reached their monthly reminder limit"
    end

    phone_number_setting = user.settings.where(key: Setting::KEYS[:phone_number]).first
    callback_number = phone_number_setting.value unless phone_number_setting.nil?

    message_text = "#{contact.name}, this is a reminder for your appt with #{user.name} "\
      "@ #{start.localtime.strftime('%l:%M %p %-m/%e/%y')}. "\
      "Call #{callback_number.blank? ? 'them' : callback_number} if you can't keep it."

    phone_number = contact.phone_number

    twilio_api_client.send_sms_message(phone_number, message_text)

    reminder_history_entries.create
  end

  def reminder_sent?
    reminder_history_entries.count > 0
  end

  class << self
    def unreminded_upcoming
      unreminded = find_by_sql(
        "SELECT * FROM ( "\
          "SELECT appointments.*, count(reminder_history_entries.id) AS reminder_count "\
          "FROM appointments "\
          "LEFT OUTER JOIN reminder_history_entries "\
            "ON appointments.id = reminder_history_entries.appointment_id "\
          "WHERE appointments.deleted = false "\
          "GROUP BY appointments.id "\
        ") AS apt_reminders "\
        "WHERE reminder_count = 0 AND apt_reminders.start > UTC_TIMESTAMP();")

      user_reminder_advance_times = {}
      unreminded.select do |apt|
        unless user_reminder_advance_times[apt.user_id]
          user_reminder_advance_times[apt.user_id] = 
            apt.settings.where(key: Setting::KEYS[:reminder_advance_time]).first.base_units_normalized_value
        end

        # time addition is in seconds, the normalized reminder advance time is in minutes
        apt.start < (Time.now.utc + user_reminder_advance_times[apt.user_id] * 60)
      end
    end
  end

  private

  def twilio_api_client
    @@client ||= TwilioApi.new
  end
end
