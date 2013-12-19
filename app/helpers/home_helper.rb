module HomeHelper
  def authenticate_with_google
    # Initialize the client & Google+ API
    require 'google/api_client'
    client = Google::APIClient.new
    plus = client.discovered_api('plus')

    # Initialize OAuth 2.0 client    
    client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'
    client.authorization.redirect_uri = 'http://lvh.me:3000/auth_callback'
    
    client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

    # Request authorization
    redirect_uri = client.authorization.authorization_uri

    # Wait for authorization code then exchange for token
    client.authorization.code = '....'
    client.authorization.fetch_access_token!

    # Make an API call
    result = client.execute(
      :api_method => plus.activities.list,
      :parameters => {'collection' => 'public', 'userId' => 'me'}
    )

    result.data
  end
end
