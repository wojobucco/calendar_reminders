require_relative 'google_api'

class Calendar

  def initialize(api_client)
    @api_client = api_client
  end

  def find_all_calendars
    service = @api_client.discovered_api 'calendar', 'v3'
    @api_client.authorization.access_token = session['access_token']
    result = @api_client.execute(
      :api_method => service.calendar_list.get,
      :parameters => { 'calendarId' => nil },
      :authorization => @api_client.authorization
      )

    return result.data
  end
end
