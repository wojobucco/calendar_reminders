class SettingsController < ApplicationController
  before_action :authorize

  def index
    @settings = Setting.where(user_id: current_user.id)
  end
end
