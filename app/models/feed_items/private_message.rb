module FeedItems
  class PrivateMessage < FeedItem

    def self.conversation_between(user1, user2, limit = nil)
      return [] if user1.nil? || user2.nil?
      ids = { user1_id: user1.id, user2_id: user2.id }
      messages = where(feedable_type: 'User').where(<<-SQL, ids)
        feedable_id = :user1_id AND author_id = :user2_id OR
        feedable_id = :user2_id AND author_id = :user1_id
      SQL
      if limit
        messages.order(created_at: :desc).limit(limit).reverse
      else
        messages.order(created_at: :asc)
      end
    end
  end
end
