module FeedPolicies
  class FeedItemsBlockedFromUser < FeedPolicy
    belongs_to :user
  end
end
