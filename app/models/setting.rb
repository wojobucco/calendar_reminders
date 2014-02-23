class Setting < ActiveRecord::Base
  extend Enumerize

  KEYS = {
    :reminder_advance_time => 0
  }

  UNITS = {
    :minutes => 0,
    :hours => 1,
    :days => 2
  }

  belongs_to :user

  validates_presence_of :key, :value, :user_id

  enumerize :key, in: KEYS

  enumerize :units, in: UNITS
end
