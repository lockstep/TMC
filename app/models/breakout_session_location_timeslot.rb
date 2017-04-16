class BreakoutSessionLocationTimeslot < ActiveRecord::Base
  belongs_to :breakout_session_location
  belongs_to :breakout_session

  delegate :name, :capacity, to: :breakout_session_location,
    prefix: true

  scope :available, -> { where(breakout_session_id: nil) }

  def select_name
    "#{day.strftime("%A %b %e")}, " +
      "#{start_time.strftime("%H:%M")} - #{end_time.strftime("%H:%M")} at " +
      "#{breakout_session_location_name}" +
      " (capacity of #{breakout_session_location_capacity})"
  end
end
