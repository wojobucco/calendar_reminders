require 'twilio-ruby'

class MessagesController < ApplicationController
  before_action :authorize

  def create
    contact = Contact.find(params[:contact_id])
    appointment = Appointment.find(params[:appointment_id])
    send_message(appointment, contact)

    flash[:success] = "Message sent"
    redirect_to appointments_url
  end

  private 
  
  def send_message(appointment, contact)
    config = YAML.load_file("#{Rails.root}/config/twilio_api.yml")

    account_sid = config['account_sid']
    auth_token = config['auth_token']

    @client = Twilio::REST::Client.new account_sid, auth_token
     
    message = @client.account.messages.create(
      :body => "#{contact.name}, this is a reminder for your appointment on #{appointment.start.to_s}. Please call if you need to cancel",
      :to => contact.phone_number,
      :from => "+14122084627")
    puts message.to
  end
end
