class Appointment < ActiveRecord::Base
  
  @@client ||= TwilioApi.new
  
  belongs_to :user
  belongs_to :contact
  
  def send_reminder
    message_text = "#{contact.name}, this is a reminder for your appointment on "\
      "#{start.to_s}. Please call if you need to cancel"
    phone_number = contact.phone_number

    @@client.send_sms_message(phone_number, message_text)
  end
end
