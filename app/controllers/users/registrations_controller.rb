class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super

    if resource.persisted?
      if session[:alternate_onboarding_function].blank?
        resource.set_up_registering_user!
      else
        resource.send(session[:alternate_onboarding_function])
        session.delete(:alternate_onboarding_function)
      end
    end
  end

end
