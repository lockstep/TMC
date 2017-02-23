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

  delegate :name, to: :conference, prefix: true
  delegate :slug, to: :conference, prefix: true

  def comments(page = 1, per = 15)
    FeedItems::BreakoutSessionComment.where(
      feedable_type: 'BreakoutSession',
      feedable_id: id
    ).order(created_at: :desc).page(page).per(per)
  end

end
