class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    @appointments = Appointment.where(user_id: current_user.id)
  end

  def new
    @contacts = Contact.where(user_id: current_user.id)
  end

  def create
    apt_params = parse_appointment_params
    apt_params.merge!(user_id: current_user.id)
    appointment = Appointment.create(apt_params)

    if (appointment.persisted?)
      flash[:success] = "Appointment saved successfully"
      redirect_to appointments_path
    else
      flash.now[:error] = "There was a problem saving your appointment"
      render :new
    end
  end

  def update
    apt = Appointment.find(params[:id].to_i)

    apt_params = parse_appointment_params
    apt_params.merge!(user_id: current_user.id)

    apt.update(apt_params)

    if (apt.persisted?)
      flash[:success] = "Appointment saved successfully"
      redirect_to appointments_path
    else
      flash.now[:error] = "There was a problem saving your appointment"
      render :edit
    end
  end

  def edit
    @appointment = Appointment.find(params[:id].to_i)
    @contacts = Contact.all.where(user_id: current_user.id)
  end

  def destroy
    apt = Appointment.find(params[:id])
    apt.destroy

    if (!apt.persisted?)
      flash[:success] = "Appointment deleted successfully"
    else
      flash[:error] = "Appointment was not deleted succesfully"
    end

    redirect_to appointments_path
  end

  def send_reminder
    @appointment = Appointment.find(params[:id].to_i)

    begin
      success = @appointment.send_reminder
    rescue => e
      success = false
      flash[:error] = "This functionality is currently only available for phone numbers that have been verified by the admin."
    end

    if success
      flash[:success] = "Reminder was sent successfully"
    else
      flash[:error] ||= "Reminder was not sent successfully. Please contact technical support"
    end

    redirect_to appointments_path
  end

  private

  def parse_appointment_params
    start_str = "#{params[:start_date]} #{params[:start_time]}"
    
    begin
      apt_start = Time.parse(start_str)
      apt_end = apt_start + (params[:duration].to_i * 60)

      return { start: apt_start, end: apt_end, contact_id: params[:contact][:contact_id] }
    rescue
      return {}
    end
  end
end
