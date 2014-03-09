# Load the Rails application.
require File.expand_path('../application', __FILE__)

# load the secret environment configuration
secrets_file = File.expand_path('../secrets.rb', __FILE__)
load secrets_file if File.exist?(secrets_file)

# Initialize the Rails application.
CalendarReminders::Application.initialize!
