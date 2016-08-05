class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    WelcomeNewUserWorker.perform_async(resource.id) if resource.persisted?
  end
end
