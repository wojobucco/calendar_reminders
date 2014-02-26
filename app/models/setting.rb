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

  def base_units_normalized_value
    case units.to_sym
      when :minutes
        value.to_i
      when :hours
        value.to_i * 60
      when :days
        value.to_i * 60 * 24
      else
        raise StandardError "Invalid setting value/units"
    end
  end
end
