# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# example:
#
set :output, "#{Rails.root}/log/cron_log.log"

every 1.minute do
  command "/var/www/apps/calendar-reminders/shared/scripts/env_variables.sh"
  runner "Appointment.unreminded_upcoming.each { |apt| apt.send_reminder }"
end
