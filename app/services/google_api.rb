class GoogleApi

  def initialize(access_token)
    @access_token = access_token
    @api_client = create_api_client
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

    # Initialize OAuth 2.0 client    
    client.authorization.client_id = '689299727081-pvre0jugh5l6cfg2l5e18us4msu8udom.apps.googleusercontent.com'
    client.authorization.client_secret = 'pI8RdUmDmbUloV1pZnR_rPm4'

    return client
  end

end
