class SettingsController < ApplicationController
  before_action :authorize

  def index
    @settings = Setting.where(user_id: current_user.id)
  end

  def update
    @setting = Setting.find(params[:id])

    raise SecurityError.new unless @setting.user_id = current_user.id

    units_param = "#{@setting.key}_units".to_sym

    value = params[:setting][:value]
    units = params[units_param].to_sym if params[units_param]

    respond_to do |format|
      if @setting.update_attributes(:value => value, :units => units)
        format.html do 
          flash[:success] = "#{@setting.key.humanize} was updated sucessfully."
          redirect_to settings_url
        end

        format.json { render json: @setting }
      else
        format.html do
          flash[:error] = "#{@setting.key.humanize} was not updated sucessfully."
          redirect_to settings_url
        end

        format.json do
          render json: { errors: @setting.errors.full_messages }, status: :bad_request
        end
      end
    end
  end
end
