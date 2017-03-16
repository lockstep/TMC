module UsersHelper
  def clear_devise_reset_password_token
    clear_reset_password_token
    save
  end
end
