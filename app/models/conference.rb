class Conference < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :breakout_sessions
  has_many :breakout_session_locations
  has_many :breakout_session_timeslots, through: :breakout_session_locations
end
