namespace :production do
  task :send_reminders do
    `/var/www/apps/calendar-reminders/shared/scripts/env_variables.sh`
    Appointment.unreminded_upcoming.each { |apt| apt.send_reminder }   
  end
end
