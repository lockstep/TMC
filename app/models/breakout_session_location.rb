class BreakoutSessionLocation < ActiveRecord::Base
  belongs_to :conference
  has_one :breakout_session

  has_many :breakout_session_timeslots,
    class_name: 'BreakoutSessionLocationTimeslot'

end
