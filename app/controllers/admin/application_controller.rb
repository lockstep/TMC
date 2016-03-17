# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      raise_404 unless is_current_user_admin?
    end

    private

    def raise_404
      raise ActionController::RoutingError, 'Not Found'
    end

    def is_current_user_admin?
      if current_user
        current_user.role == 'admin'
      else
        false
      end
    end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
