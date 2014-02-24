class RemindersController < ApplicationController
  before_action :authorize

  def create
    contact = Contact.find(params[:contact_id])
    appointment = Appointment.find(params[:appointment_id])

    Reminder.send_sms_message(appointment, contact)

    flash[:success] = "Message sent"
    redirect_to appointments_url
  end
  
end
