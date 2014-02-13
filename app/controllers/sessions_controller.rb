class SessionsController < ApplicationController

  def new
    client = GoogleApi.new(redirect_uri: sessions_authorize_url)
    redirect_to client.authorization_uri
  end

  def authorize
    if params[:code]
      client = GoogleApi.new(redirect_uri: sessions_authorize_url,
        code: params[:code])
      result = client.get_user_info

      found_user = User.find_or_create_by(google_id: result.data.id) do |user|
        user.name = result.data.name
        user.email = result.data.email
        user.refresh_token = client.refresh_token
      end

      if (found_user.refresh_token != client.refresh_token)
        found_user.update(refresh_token: client.refresh_token)
        found_user.save
      end

      session['user_id'] = found_user.id
      session['access_token'] = client.access_token

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
end
