class Oauth2callbackController < ApplicationController
  def index
    session[:auth_code] = params[:code]

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

    client.authorization.code = session[:auth_code]
    client.authorization.fetch_access_token!

    @plus = client.discovered_api('plus')

    @result = client.execute(
      :api_method => @plus.activities.list,
      :parameters => { 'collection' => 'public',
        'userId' => 'me' }
    )

  end
end
