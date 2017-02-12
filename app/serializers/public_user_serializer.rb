class PublicUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :position,
    :organization_name, :address_country, :avatar_url_thumb,
    :avatar_url_small, :avatar_url_medium, :full_address_country,
    :position_with_organization

  def avatar_url_thumb
    object.avatar.url(:thumb)
  end

  def avatar_url_small
    object.avatar.url(:small)
  end

  def avatar_url_medium
    object.avatar.url(:medium)
  end

  def position_with_organization
    return object.position if object.organization_name.blank?
    "#{object.position} at #{object.organization_name}"
  end
end
