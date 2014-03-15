require File.expand_path("../../../config/environment", __FILE__)
require_relative "task_helpers/production"

extend TaskHelpers::Production

namespace :production do
  desc "Send all reminders to contacts with appointments within the time window"
  task :send_reminders do |task|
    Rails.application.eager_load!

    appointments = Appointment.unreminded_upcoming

    if appointments.empty?
      log task, :info, "No unreminded upcoming appointments found"
    else
      appointments.each do |apt| 
        begin
          log task, :info, "Sending reminder to contact_id: #{apt.contact.id} for user_id: #{apt.user.id}"
          apt.send_reminder
        rescue => e
          log task, :error,  "Error sending reminder to contact_id: #{apt.contact.id} for user_id: #{apt.user.id} "\
            "#{e.message} : #{e.backtrace}"
        end
      end
    end
  end
end
