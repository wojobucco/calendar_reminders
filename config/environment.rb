# Load the Rails application.
require File.expand_path('../application', __FILE__)

# load the secret environment configuration
if File.exist?(File.expand_path('../secret.rb', __FILE__))
  load File.expand_path('../secret.rb', __FILE__)
end

# Initialize the Rails application.
CalendarReminders::Application.initialize!
