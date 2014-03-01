class GoogleApi

  def initialize(params = {})
    @api_client = create_api_client
    @api_client.authorization.redirect_uri = params[:redirect_uri]

    if params[:code] && params[:access_token]
      raise StandardError.new "Either code or access token, not both!"
    elsif params[:code]
      @api_client.authorization.code = params[:code]
      @api_client.authorization.fetch_access_token!
    elsif params[:access_token]
      @api_client.authorization.access_token = params[:access_token]
    end

  end

  def authorization_uri
    Signet::OAuth2.generate_authorization_uri(@api_client.authorization.authorization_uri)
  end

  def access_token
    @api_client.authorization.access_token
  end

  def refresh_token
    @api_client.authorization.refresh_token
  end

  def get_user_info
    oauth2 = @api_client.discovered_api 'oauth2'
    result = @api_client.execute(
      :api_method => oauth2.userinfo.get
      )
  end

  def get_all_contacts
    #todo: make this work
    service = @api_client.discovered_api 'contacts', 'v3'
    @api_client.authorization.access_token = @access_token
    result = @api_client.execute(
      :api_method => service.contact_list.get,
      :authorization => @api_client.authorization
      )

    return result.data
  end

  def get_all_calendars
    service = @api_client.discovered_api 'calendar', 'v3'
    @api_client.authorization.access_token = @access_token
    result = @api_client.execute(
      :api_method => service.calendar_list.get,
      :parameters => { 'calendarId' => nil },
      :authorization => @api_client.authorization
      )

    return result.data
  end

  def get_all_events_by_calendar(calendar)
    service = @api_client.discovered_api 'calendar', 'v3'
    @api_client.authorization.access_token = @access_token

    param_list = {
      :api_method => service.events.list,
      :parameters => { 
        'calendarId' => calendar['id'],
        'timeMin' => Time.now.strftime('%Y-%m-%dT%H:%M:%S%:z'),
        'timeMax' => (Time.now + 1.months).strftime('%Y-%m-%dT%H:%M:%S%:z'),
        'singleEvents' => true,
        'orderBy' => 'startTime' }
      }

    result = @api_client.execute(param_list)

    result.data.items
  end

  private

  def create_api_client
    # Initialize the client & Google+ API
    client = Google::APIClient.new(
      application_name: 'Calendar Reminders',
      application_version: '0.0.1')

    client.authorization.scope = [
      'https://www.googleapis.com/auth/userinfo.email', 
      'https://www.googleapis.com/auth/userinfo.profile'
      ]

    # Initialize OAuth 2.0 client    
    client.authorization.client_id = APP_CONFIG['google_api']['client_id']
    client.authorization.client_secret = APP_CONFIG['google_api']['client_secret']

    return client
  end

end
