class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    @appointments = Appointment.where(user_id: current_user.id)
  end

  def new
    @appointment = Appointment.new(user_id: current_user.id)
  end

  def create
    start_str = "#{params[:start_date]} #{params[:start_time]}"
    apt_start = Time.parse(start_str)
    apt_end = apt_start + (params[:duration].to_i * 60)
    
    appointment = Appointment.create(user_id: current_user.id, start: apt_start, end: apt_end)

    if (appointment.persisted?)
      flash[:success] = "Appointment saved successfully"
      redirect_to appointments_path
    else
      flash.now[:error] = "There was a problem saving your appointment"
      render :new
    end
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
end
