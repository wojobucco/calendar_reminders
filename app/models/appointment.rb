require_relative '../services/twilio_api'

class Appointment < ActiveRecord::Base

  belongs_to :user
  belongs_to :contact

  has_many :reminder_history_entries, dependent: :destroy
  has_many :settings, through: :user

  scope :upcoming, -> { where("start > ?", Time.now) }
  scope :past, -> { where("start < ?", Time.now) }

  def send_reminder
    if self.reminder_sent?
      raise StandardError.new "A reminder was already sent for this appointment."
    end

    message_text = "#{contact.name}, this is a reminder for your appointment at "\
      "#{start.localtime.strftime('%a %b %e %Y, %l:%M %p')}. Please call if you need to cancel"
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
          "GROUP BY appointments.id "\
        ") AS apt_reminders "\
        "WHERE reminder_count = 0 AND apt_reminders.start > UTC_TIMESTAMP();")

      user_reminder_advance_times = {}
      unreminded.select do |apt|
        unless user_reminder_advance_times[apt.user_id]
          user_reminder_advance_times[apt.user_id] = apt.settings.where(key: :reminder_advance_time).first.base_units_normalized_value
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
