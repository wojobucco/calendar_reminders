class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    @appointments = Appointment.all.where(user_id: current_user.id)
    puts 'hello'
  end

  def new
    @contacts = Contact.all.where(user_id: current_user.id)
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
    apt_params.merge!(user_id: current_user.id, contacts_id: params[:contact][:contact_id].to_i)

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

  private

  def parse_appointment_params
    start_str = "#{params[:start_date]} #{params[:start_time]}"
    
    begin
      apt_start = Time.parse(start_str)
      apt_end = apt_start + (params[:duration].to_i * 60)

      return { start: apt_start, end: apt_end }
    rescue
      return {}
    end
  end
end
