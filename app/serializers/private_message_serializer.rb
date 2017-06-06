class PrivateMessageSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :message, :created_at_time_ago_in_words
  has_one :author, serializer: PublicUserSerializer

  def created_at_time_ago_in_words
    time_ago_in_words(object.created_at)
  end
end
