class OrganizerSerializer < ActiveModel::Serializer
  attributes :user_id, :full_name

  def full_name
    object.user_full_name
  end
end
