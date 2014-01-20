class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    service = @client.discovered_api 'calendar', 'v3'
    @client.authorization.access_token = session['access_token']
    result = @client.execute(
      :api_method => service.calendar_list.get,
      :parameters => { 'calendarId' => nil },
      :authorization => @client.authorization
      )

    @calendars = result.data

    @events = []
    @calendars.items.each do |calendar|
      param_list = {
        :api_method => service.events.list,
        :parameters => { 
          'calendarId' => calendar['id'],
          'timeMin' => Time.now.strftime('%Y-%m-%dT%H:%M:%S%:z'),
          'timeMax' => (Time.now + 1.months).strftime('%Y-%m-%dT%H:%M:%S%:z'),
          'singleEvents' => true,
          'orderBy' => 'startTime' }
        }

      result = @client.execute(param_list)

      @events.concat result.data.items
    end

  end

end
