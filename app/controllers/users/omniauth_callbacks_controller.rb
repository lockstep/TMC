class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(
      env["omniauth.auth"], current_user, session[:alternate_onboarding_function]
    )

    if @user.present?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      session.delete(:alternate_onboarding_function)
      @user.clear_devise_reset_password_token
    else
      unless env["omniauth.auth.info.email"]
        flash[:alert] = "Signing up with Facebok only works when you provide " \
          "an email address. Please sign up using the form below."
      end
      redirect_to new_user_registration_url
    end
  end
end
