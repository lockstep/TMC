class CommentSerializer < ActiveModel::Serializer
  attributes :id, :message, :image_url_large

  def image_url_large
    return unless object.image?
    object.image&.url(:large)
  end
end
