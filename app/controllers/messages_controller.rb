require 'twilio-ruby'

class MessagesController < ApplicationController
  before_action :authorize

  def create
    send_message(nil)

    flash[:success] = "Message sent"
    redirect_to appointments_url
  end

  private 
  
  def send_message(phone_number)
    config = YAML.load_file("#{Rails.root}/config/twilio_api.yml")

    account_sid = config['account_sid']
    auth_token = config['auth_token']

    @client = Twilio::REST::Client.new account_sid, auth_token
     
    message = @client.account.messages.create(:body => "Jenny please?! I love you <3",
        :to => "+14125353745",
        :from => "+14122084627")
    puts message.to
  end
end
