class ProfileController < ApplicationController
  before_action :authorize

  def show
    @user = User.find_by_id(params[:id])
  end
end
