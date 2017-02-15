class BreakoutSession < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :conference
  belongs_to :location, class_name: 'BreakoutSessionLocation',
    foreign_key: 'breakout_session_location_id'

  has_many :organized_breakout_sessions
  has_many :organizers, through: :organized_breakout_sessions,
    source: :user
  has_many :breakout_session_attendees
  has_many :attendees, through: :breakout_session_attendees,
    source: :user
  has_many :comments, class_name: 'BreakoutSessionComment',
    foreign_key: 'breakout_session_id'

  delegate :name, to: :conference, prefix: true
  delegate :slug, to: :conference, prefix: true
end
