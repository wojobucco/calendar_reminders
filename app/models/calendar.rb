class Calendar
  class << self
    attr_accessor :api_client

    def initialize
      @api_client = GoogleApi.new(nil)
    end

    def find_all_calendars
      @api_client.get_all_calendars
    end
  end
end
