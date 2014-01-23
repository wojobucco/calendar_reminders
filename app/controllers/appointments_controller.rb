class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    client = GoogleApi.new(session['access_token'])
    Calendar.api_client = client

    @calendars = Calendar.find_all_calendars

    Event.api_client = client
    @events = []

    @calendars.items.each do |calendar|
      @events.concat Event.find_all_events_by_calendar(calendar)
    end

  end

end
