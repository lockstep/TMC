class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super

    if resource.persisted?
      resource.set_up_registering_user!
    end
  end

end
