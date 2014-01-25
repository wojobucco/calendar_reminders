class Calendar
  class << self
    attr_accessor :api_client

    def initialize
    end

    def find_all_calendars
      raw_cals = @api_client.get_all_calendars
      return raw_cals.items
    end
  end
end
