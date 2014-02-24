require 'twilio-ruby'

class TwilioApi

  def initialize
    config = YAML.load_file("#{Rails.root}/config/api.yml")

    account_sid = config['Twilio']['account_sid']
    auth_token = config['Twilio']['auth_token']

    @account_phone_number = config['Twilio']['phone_number']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_sms_message(phone_number, message_text)
    message = @client.account.messages.create(
      :body => message_text,
      :to => phone_number,
      :from => @account_phone_number)
  end
end
