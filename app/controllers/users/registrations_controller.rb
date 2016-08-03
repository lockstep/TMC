class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    WelcomeNewUserWorker.perform_async(resource.id)
  end
end
