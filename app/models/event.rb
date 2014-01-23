class Event
  class << self
    attr_accessor :api_client

    def initialize
      @api_client = GoogleApi.new(nil)
    end

    def find_all_events_by_calendar(calendar)
      @api_client.get_all_events_by_calendar(calendar)
    end
  end
end
