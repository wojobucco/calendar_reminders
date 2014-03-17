class SettingsController < ApplicationController
  before_action :authorize

  def index
    @settings = Setting.where(user_id: current_user.id)
  end

  def update
    setting_value = params[:setting][:value]
    setting_units = params[:time_units].to_sym if params[:time_units]

    @setting = Setting.update(params[:id], value: setting_value, units: setting_units)

    respond_to do |format|
      if @setting.persisted?
        format.html { redirect_to settings_url }
        format.json { render json: @setting }
      else
        format.html { render nothing: true, status: :bad_request }
        format.json do
          render json: { errors: @setting.errors.full_messages }, status: :bad_request
        end
      end
    end
  end
end
