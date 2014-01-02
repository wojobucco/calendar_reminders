class SessionsController < ApplicationController

  def new
    @client.authorization.scope = [
      'https://www.googleapis.com/auth/userinfo.email', 
      'https://www.googleapis.com/auth/userinfo.profile'
      ]

    redirect_to auth_request_uri
  end

  def authorize
    if params[:code]
      @client.authorization.code = params[:code]
      @client.authorization.fetch_access_token!

      oauth2 = @client.discovered_api 'oauth2'
      result = @client.execute(
        :api_method => oauth2.userinfo.get,
        :authorization => @client.authorization
      )

      found_user = User.find_or_create_by(google_id: result.data.id) do |user|
        user.name = result.data.name
        user.email = result.data.email
        user.refresh_token = @client.authorization.refresh_token
      end

      if (found_user.refresh_token != @client.authorization.refresh_token)
        found_user.update(refresh_token: @client.authorization.refresh_token)
        found_user.save
      end

      session['user_id'] = found_user.id
      session['access_token'] = @client.authorization.access_token

      redirect_to root_path
    else
      flash[:notice] = params[:error]
      redirect_to root_path
    end
  end

  def destroy
    revoke_response = HTTParty.get "https://accounts.google.com/o/oauth2/revoke?token=#{session['access_token']}"

    current_user = User.find(session['user_id'])
    current_user.update(refresh_token: nil)
    current_user.save

    reset_session
    redirect_to root_path
  end

  private

  def auth_request_uri
    Signet::OAuth2.generate_authorization_uri(@client.authorization.authorization_uri)
  end
end
