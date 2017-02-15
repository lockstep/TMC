class Conference < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :breakout_sessions
  has_many :breakout_session_locations
end
