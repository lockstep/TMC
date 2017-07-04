module Api
  module V1
    class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :null_session
    end
  end
end
