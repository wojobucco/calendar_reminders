require 'twilio-ruby'

class TwilioApi

  def initialize
    account_sid = APP_CONFIG['twilio_api']['account_sid']
    auth_token = APP_CONFIG['twilio_api']['auth_token']

    @account_phone_number = APP_CONFIG['twilio_api']['phone_number']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_sms_message(phone_number, message_text)
    message = @client.account.messages.create(
      :body => message_text,
      :to => phone_number,
      :from => @account_phone_number)
  end
end
