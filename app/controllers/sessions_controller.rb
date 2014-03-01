require 'csv'

class SessionsController < ApplicationController

  before_action do
    @@beta_users ||= load_beta_users
  end

  def new
    client = GoogleApi.new(redirect_uri: sessions_authorize_url)
    redirect_to client.authorization_uri
  end

  def authorize
    if params[:code]
      client = GoogleApi.new(redirect_uri: sessions_authorize_url,
        code: params[:code])
      result = client.get_user_info

      #todo: remove this when beta has concluded
      unless @@beta_users.include?(result.data.email)
        redirect_to info_beta_notice_path
        return
      end

      found_user = User.find_or_create_by(google_id: result.data.id) do |user|
        user.name = result.data.name
        user.email = result.data.email
        user.refresh_token = client.refresh_token
        user.save
      end

      found_user.set_default_user_settings

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

  private

  def load_beta_users
    return CSV.parse(APP_CONFIG['beta_users']).flatten
  end

end
