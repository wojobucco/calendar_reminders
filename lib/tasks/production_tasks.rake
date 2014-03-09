require File.expand_path("../../../config/environment", __FILE__)

namespace :production do
  desc "Send all reminders to contacts with appointments within the time window"
  task :send_reminders do
    Appointment.unreminded_upcoming.each { |apt| apt.send_reminder }   
  end
end
