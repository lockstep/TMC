include ActionView::Helpers::DateHelper

class PrivateMessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at_time_ago_in_words

  def created_at_time_ago_in_words
    time_ago_in_words(object.created_at)
  end
end
