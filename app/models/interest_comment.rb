class InterestComment < FeedItem
  belongs_to :interest
  belongs_to :user

  validates_presence_of :message
end
