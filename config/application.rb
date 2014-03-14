require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module CalendarReminders
  class Application < Rails::Application

    config.i18n.enforce_available_locales = true
     
    load File.expand_path('../version.rb', __FILE__)
  end
end
