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

      found_user = User.find_or_create_by(google_id: result.data.id) do |user|
        user.name = result.data.name
        user.email = result.data.email
        user.refresh_token = client.authorization.refresh_token
      end

      if (found_user.refresh_token != client.authorization.refresh_token)
        found_user.update(refresh_token: client.authorization.refresh_token)
        found_user.save
      end

      session['user_id'] = found_user.id
      session['access_token'] = client.authorization.access_token

      redirect_to root_path
    elsif params[:error]
      flash[:notice] = params[:error]
      redirect_to root_path
    else
      redirect_to auth_request_uri
    end
  end

  def destroy
    revoke_response = HTTParty.get "https://accounts.google.com/o/oauth2/revoke?token=#{session['access_token']}"

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
    client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'
    client.authorization.redirect_uri = new_session_url
    client.authorization.scope = [
      'https://www.googleapis.com/auth/userinfo.email', 
      'https://www.googleapis.com/auth/userinfo.profile'
      ]

    return client
  end

  def auth_request_uri
    Signet::OAuth2.generate_authorization_uri(api_client.authorization.authorization_uri)
  end
end
