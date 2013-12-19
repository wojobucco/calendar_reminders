class HomeController < ApplicationController
  include HomeHelper

  def index
    authenticate_with_google
  end
end
