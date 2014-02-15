class Setting < ActiveRecord::Base
  extend Enumerize

  KEYS = {
    :reminder_advance_time => 0
  }

  belongs_to :user

  validates_presence_of :key, :value, :user_id

  enumerize :key, in: KEYS
end
