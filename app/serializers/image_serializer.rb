class ImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url_large, :owner,
    :avatar_url_thumb, :avatar_url_small, :avatar_url_medium

  def image_url_large
    object.image&.url(:large)
  end

  def owner
    object.author.full_name
  end

  def avatar_url_thumb
    object.author.avatar.url(:thumb)
  end

  def avatar_url_small
    object.author.avatar.url(:small)
  end

  def avatar_url_medium
    object.author.avatar.url(:medium)
  end
end
