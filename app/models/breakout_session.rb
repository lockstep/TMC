class BreakoutSession < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :conference
  belongs_to :location, class_name: 'BreakoutSessionLocation',
    foreign_key: 'breakout_session_location_id'

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

  delegate :name, to: :conference, prefix: true
  delegate :slug, to: :conference, prefix: true

end
