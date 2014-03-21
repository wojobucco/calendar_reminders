module AppointmentsHelper
  def now_rounded_to_next_hour
    hour_from_now = Time.now + 1.hour

    return Time.new(
      hour_from_now.year,
      hour_from_now.month,
      hour_from_now.day,
      hour_from_now.hour,
      0,
      0)
  end
end
