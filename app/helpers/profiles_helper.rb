module ProfilesHelper
  def avatar_url(user)
    return user.avatar.url if user.avatar.exists?
    image_path 'montessori_avatar'
  end
end
