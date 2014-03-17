module Helpers
  module UserHelpers
    def get_setting_by_key(settings, key)
      settings.select { |c| c.key == key.to_s }.first
    end
  end
end
