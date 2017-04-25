class ImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url_large

  def image_url_large
    object.image&.url(:large)
  end
end
