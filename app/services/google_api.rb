class GoogleApi

  def initialize(access_token)
    @access_token = access_token
    @api_client = create_api_client
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

    config = YAML.load_file("#{Rails.root}/config/google_api.yml")

    # Initialize OAuth 2.0 client    
    client.authorization.client_id = config['client_id']
    client.authorization.client_secret = config['client_secret']

    return client
  end

end
