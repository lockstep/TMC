class Users::SessionsController < Devise::SessionsController
  after_action :destroy_session_after_sign_in_path, only: :destroy

  private

  def destroy_session_after_sign_in_path
    store_location_for(:user, root_path)
  end
end
