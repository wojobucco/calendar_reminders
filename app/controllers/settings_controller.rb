class SettingsController < ApplicationController
  before_action :authorize

  def index
    @settings = Setting.where(user_id: current_user.id)
  end

  def update
    setting_value = params[:setting][:value].to_i

    case params[:time_units].to_sym
      when :minutes
        setting_value
      when :hours
        setting_value *= 60
      when :days
        setting_value *= 60 * 24
      else
        #don't change value
    end

    @setting = Setting.update(params[:id], value: setting_value)

    respond_to do |format|
      if @setting.persisted?
        format.html { redirect_to settings_url }
        format.json { render json: @setting }
      else
        flash.now[:error] = "Could not update setting"
      end
    end
  end
end
