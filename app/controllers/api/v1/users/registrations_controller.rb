module Api
  module V1
    class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :null_session
      before_action :configure_sign_up_params

      protected

      def configure_sign_up_params
        devise_parameter_sanitizer.for(:sign_up) << [
          :first_name, :last_name, :position, :organization_name,
          :address_city, :address_state, :address_country,
          :opted_in_to_public_directory
        ]
      end
    end
  end
end
