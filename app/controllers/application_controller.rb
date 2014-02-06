class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter do
    @client ||= create_api_client
  end

  protected

  def current_user
    User.find(session['user_id']) if session['user_id']
  end

  def authorize
    redirect_to root_path unless current_user
  end

  def create_api_client
    # Initialize the client & Google+ API
    client = Google::APIClient.new(
      application_name: 'Calendar Reminders',
      application_version: '0.0.1')

    config = YAML.load_file("#{Rails.root}/config/google_api.yml")

    # Initialize OAuth 2.0 client    
    client.authorization.client_id = config['client_id']
    client.authorization.client_secret = config['client_secret']

    client.authorization.redirect_uri = sessions_authorize_url

    return client
  end

end
