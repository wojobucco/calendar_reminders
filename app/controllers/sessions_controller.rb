require 'base64'
require 'json'

class SessionsController < ApplicationController

  def new
    if params[:code]
      client = api_client
      client.authorization.code = params[:code]
      client.authorization.fetch_access_token!

      oauth2 = client.discovered_api 'oauth2'
      result = client.execute(
        :api_method => oauth2.userinfo.get,
        :authorization => client.authorization
      )

      user = User.create(
        email: result.data.email,
        refresh_token: client.authorization.refresh_token
      )

      session['user_id'] = user.id

      redirect_to root_path
    else
      redirect_to auth_request_uri
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def api_client
    # Initialize the client & Google+ API
    client = Google::APIClient.new(
      application_name: 'Calendar Reminders',
      application_version: '0.0.1')

    # Initialize OAuth 2.0 client    
    client.authorization = :oauth_2
    client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'
    client.authorization.redirect_uri = new_session_url
    client.authorization.scope = 'email'

    return client
  end

  def auth_request_uri
    Signet::OAuth2.generate_authorization_uri(api_client.authorization.authorization_uri)
  end
end
