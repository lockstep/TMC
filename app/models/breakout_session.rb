class BreakoutSession < ActiveRecord::Base
  belongs_to :conference
  belongs_to :location, class_name: 'BreakoutSessionLocation',
    foreign_key: 'breakout_session_location_id'

  has_many :organized_breakout_sessions
  has_many :organizers, through: :organized_breakout_sessions,
    source: :user
end
