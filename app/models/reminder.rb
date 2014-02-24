class Reminder

  class << self
    @@client = TwilioApi.new

    def send_sms_message(appointment, contact)
      message_text = "#{contact.name}, this is a reminder for your appointment on "\
        "#{appointment.start.to_s}. Please call if you need to cancel"
      phone_number = contact.phone_number

      @@client.send_sms_message(phone_number, message_text)
    end
  end
end
