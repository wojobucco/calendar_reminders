require 'google/api_client'

class HomeController < ApplicationController
  def index
    redirect_to appointments_url if current_user
  end

  private

end
