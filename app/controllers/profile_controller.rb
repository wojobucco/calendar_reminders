class ProfileController < ApplicationController
  before_action :authorize

  def index
    @user = User.find_by_id(current_user.id)
  end
end
