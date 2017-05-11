class BreakoutSession < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  validates :name, presence: true

  belongs_to :conference

  # These are the possible options in the select, but a breakout
  # session is only ever associated with one timeslot.
  has_many :breakout_session_timeslots, through: :conference

  has_many :breakout_session_supplements
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

  delegate :name, :slug, :id, to: :conference, prefix: true, allow_nil: true
  delegate :name, to: :location, prefix: true,
    allow_nil: true
  delegate :start_time, :end_time, :day,
    to: :breakout_session_location_timeslot

  scope :approved, -> { where(approved: true) }
  scope :order_by_time, -> {
    self.includes(:breakout_session_location_timeslot)
      .order( 
        <<-EOS.strip_heredoc.squish
          breakout_session_location_timeslots.day ASC,
          breakout_session_location_timeslots.start_time ASC
        EOS
      )
  }

end
