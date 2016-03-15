class Users::SessionsController < Devise::SessionsController
  after_action :destroy_session_after_sign_in_path, only: [:create]

  private

  def destroy_session_after_sign_in_path
    session.delete(:after_sign_in_path)
  end
end
