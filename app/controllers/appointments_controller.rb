class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    appt_filter = params[:filter] || :upcoming

    case appt_filter.to_sym
      when :upcoming
        @appointments = Appointment.where(user_id: current_user.id).upcoming
      when :past
        @appointments = Appointment.where(user_id: current_user.id).past
      when :all
        @appointments = Appointment.where(user_id: current_user.id)
      else
        raise StandardError.new "Unknown appointment filter type #{appt_filter}"
    end 
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
      flash.now[:error] = "There was a problem saving your appointment:\n #{appointment.errors.full_messages}"
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

    if (apt.update(deleted: true))
      flash[:success] = "Appointment deleted successfully"
    else
      flash[:error] = "Appointment was not deleted succesfully"
    end

    redirect_to appointments_path
  end

  private

  def parse_appointment_params
    start_str = "#{params[:start_date]} #{params[:start_time]}"
    
    begin
      apt_start = Time.parse(start_str)
      apt_end = apt_start + (params[:duration].to_i * 60)
      contact_id = params[:appointment][:contact_id] if params[:appointment]

      return { start: apt_start, end: apt_end, contact_id: contact_id }
    rescue
      return {}
    end
  end
end
