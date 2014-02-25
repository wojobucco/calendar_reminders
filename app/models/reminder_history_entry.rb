class ReminderHistoryEntry < ActiveRecord::Base
  belongs_to :appointment
end
