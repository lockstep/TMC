class Users::SessionsController < Devise::SessionsController
  after_action :destroy_session_after_sign_in_path, only: :destroy

  def create
    super
    current_user.clear_devise_reset_password_token if current_user
  end

  private

  def destroy_session_after_sign_in_path
    store_location_for(:user, root_path)
  end
end
