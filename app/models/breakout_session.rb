class BreakoutSession < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  validates :name, :description, presence: true

  belongs_to :conference

  # These are the possible options in the select, but a breakout
  # session is only ever associated with one timeslot.
  has_many :breakout_session_timeslots, through: :conference

  has_one :breakout_session_location_timeslot
  has_one :location, through: :breakout_session_location_timeslot,
    source: :breakout_session_location

  has_many :organized_breakout_sessions
  has_many :organizers, through: :organized_breakout_sessions,
    source: :user
  has_many :breakout_session_attendances
  has_many :attendees, through: :breakout_session_attendances,
    source: :user
  has_many :opted_in_attendees, -> {
      where(opted_in_to_public_directory: true)
    },
    through: :breakout_session_attendances,
    source: :user
  has_many :comments, as: :feedable, class_name: 'FeedItems::Comment'

  delegate :name, :slug, to: :conference, prefix: true
  delegate :name, to: :location, prefix: true
  delegate :start_time, :end_time, :day,
    to: :breakout_session_location_timeslot

  scope :approved, -> { where(approved: true) }

end
