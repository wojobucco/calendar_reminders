require 'google/api_client'
require 'google/api_client/auth/installed_app'

class HomeController < ApplicationController
  def index

  end

  def authenticate
    @auth_result = authenticate_with_google
    redirect_to @auth_result
  end

  private

  def authenticate_with_google
    # Initialize the client & Google+ API
    client = Google::APIClient.new(
      application_name: 'Calendar Reminders',
      application_version: '0.0.1')

    # Initialize OAuth 2.0 client    
    client.authorization = :oauth_2
    client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'
    client.authorization.redirect_uri = 'http://lvh.me:3000/oauth2callback/index'
    client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

    Signet::OAuth2.generate_authorization_uri(client.authorization.authorization_uri)
  end
end
