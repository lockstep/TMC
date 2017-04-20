class PrivateMessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_time_ago

  include ActionView::Helpers::DateHelper
  
  def created_time_ago
    time_ago_in_words(object.created_at)
  end
end
