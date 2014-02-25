class Appointment < ActiveRecord::Base
  
  @@client ||= TwilioApi.new
  
  belongs_to :user
  belongs_to :contact

  has_many :reminder_history_entry, dependent: :destroy
  
  def send_reminder
    message_text = "#{contact.name}, this is a reminder for your appointment on "\
      "#{start.to_s}. Please call if you need to cancel"
    phone_number = contact.phone_number

    @@client.send_sms_message(phone_number, message_text)

    reminder_history_entry.create
  end

  def reminder_sent?
    reminder_history_entry.count > 0
  end

  class << self
    def unreminded
      find_by_sql(
        "SELECT * FROM ( "\
          "SELECT appointments.*, count(reminder_history_entries.id) AS reminder_count "\
          "FROM appointments "\
          "LEFT OUTER JOIN reminder_history_entries "\
          "ON appointments.id = reminder_history_entries.appointment_id "\
          "GROUP BY appointments.id "\
        ") AS apt_reminders "\
        "WHERE reminder_count = 0;")
    end
  end
    
end
