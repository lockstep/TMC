class BreakoutSessionComment < FeedItem
  belongs_to :breakout_session
  belongs_to :user

  validates_presence_of :message

end
