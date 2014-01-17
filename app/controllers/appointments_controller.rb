class AppointmentsController < ApplicationController

  before_filter :authorize

  def index
    calendar = @client.discovered_api 'calendar', 'v3'
    @client.authorization.access_token = session['access_token']
    result = @client.execute(
      :api_method => calendar.calendar_list.get,
      :parameters => { 'calendarId' => nil },
      :authorization => @client.authorization
    )

    @calendars = result.data
  end

  private

  def authorize
    redirect_to root_path unless current_user
  end
end
