class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :create_api_client

  private

  def create_api_client
    # Initialize the client & Google+ API
    @client = Google::APIClient.new(
      application_name: 'Calendar Reminders',
      application_version: '0.0.1')

    # Initialize OAuth 2.0 client    
    @client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    @client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'
    @client.authorization.redirect_uri = sessions_authorize_url
  end

end
