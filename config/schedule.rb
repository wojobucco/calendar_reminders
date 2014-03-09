# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# example:
#
#set :output, "#{Rails.root}/log/cron_log.log"

every 1.minute do
  env :PATH, ENV['PATH']
  rake "production:send_reminders"
end
