module FeedItemHelper
  def message_sent_info(message, current_user)
    sender = message.author == current_user ?
      'You sent' : "#{message.author_first_name} sent"
    "#{sender} #{time_ago_in_words(message.created_at)} ago"
  end
end
